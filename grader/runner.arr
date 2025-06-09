import file as F
import parse-pyret as PP
import either as E
import string-dict as SD
import pathlib as Path
import file("../node_modules/pyret-lang/src/arr/compiler/repl.arr") as R
import file("../node_modules/pyret-lang/src/arr/compiler/cli-module-loader.arr") as CLI
import file("../node_modules/pyret-lang/src/arr/compiler/compile-structs.arr") as CS
import file("../node_modules/pyret-lang/src/arr/compiler/compile-lib.arr") as CL
import runtime-lib as RT
import load-lib as LL

include js-file("../proj-dir")

provide:
  run,
  load-syntax,
end

project-root = get-proj-dir()

context = {
  current-load-path: Path.resolve(project-root),
  cache-base-dir: Path.resolve("./.pyret/compiled"),
  compiled-read-only-dirs: [list: Path.join(project-root, "node_modules/pyret-npm/pyret-lang/build/phaseA/lib-compiled")],
  url-file-mode: CS.all-remote
}
repl = R.make-repl(
  RT.make-runtime(), 
  [SD.mutable-string-dict:],
  LL.empty-realm(),
  context,
  lam(): CLI.module-finder end
)

fun load-syntax(path :: String):
  content = F.file-to-string(path)
  maybe-ast = PP.maybe-surface-parse(content, path)
  cases(E.Either) maybe-ast:
    | left(err) => raise(err)
    | right(ast) => ast
  end
end


fun run(ast):
  i = repl.make-definitions-locator(lam(): "" end, CS.standard-globals).{
    method get-module(self):
      CL.pyret-ast(ast)
    end
  }
  result = repl.restart-interactions(i, CS.default-compile-options.{checks-format: "json"})
  if LL.is-success-result(result.v):
    LL.render-check-results(result.v).message
  else:
    LL.render-error-message(result.v).message
  end
end
