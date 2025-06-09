include file("grader/runner.arr")
include js-file("proj-dir")

import pathlib as Path

proj-dir = get-proj-dir()

ast = load-syntax(Path.join(proj-dir, "student/submission.arr"))
print(to-repr(run(ast)) + "\n")

