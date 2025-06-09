({
  requires: [],
  provides: {
    values: {
      "print-raw": ["arrow", [], "Nothing"],
      "print-result": ["arrow", [], "Nothing"],
    },
  },
  nativeRequires: [],
  theModule: (runtime, namespace, uri) => {
    function printRaw(val) {
      console.dir(val, { depth: 2, colors: true });
      return runtime.nothing;
    }
  
    function printResult(val) {
      console.dir(val.val.result, { colors: true })
      return runtime.nothing;
    }

    return runtime.makeModuleReturn(
      {
        "print-raw": runtime.makeFunction(printRaw, "print-raw"),
        "print-result": runtime.makeFunction(printResult, "print-result"),
      },
      {},
    );
  },
})
