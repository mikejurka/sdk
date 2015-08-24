## 1.13.0

* `dart:core`
  * `Uri` added `removeFragment` method.
  * `String.allMatches` (implementing `Pattern.allMatches`) is now lazy,
    as all `allMatches` implementations are intended to be.

* `dart:io`
  * `HttpClient` no longer sends URI fragments in the requeust. This is not
    allowed by the HTTP protocol.
    The `HttpServer` still gracefully receives fragments, but discards them
    before delivering the request.

  * `StreamController` added setters for the `onListen`, `onPause`, `onResume`
    Also added `hasAbsolutePath`, `hasEmptyPath`, and `hasScheme` properties.

* `dart:developer`
  * New `log` function to transmit logging events to Observatory.
* `dart:isolate`
  * Added `onError`, `onExit` and `errorsAreFatal` parameters to
    `Isolate.spawnUri`.

* `dart:mirrors`
  * `InstanceMirror.delegate` moved up to `ObjectMirror`.
  * Fix InstanceMirror.getField optimization when the selector is an operator.
  * Fix reflective NoSuchMethodErrors to match their non-reflective
    counterparts when due to argument mismatches. (VM only)

* Documentation tools

  * `dartdoc` is now the default tool to generate static HTML for API docs.
    [Learn more](https://pub.dartlang.org/packages/dartdoc).

  * `docgen` and `dartdocgen` have been deprecated. Currently plan is to remove
    them in 1.13.

* Formatter (`dartfmt`)

  * Over 50 bugs fixed.

  * Optimized line splitter is much faster and produces better output on
    complex code.

* Observatory
  * Allocation profiling.

  * New feature to display output from logging.

  * Heap snapshot analysis works for 64-bit VMs.

  * Improved ability to inspect typed data, regex and compiled code.

  * Ability to break on all or uncaught exceptions from Observatory's debugger.

  * Ability to set closure-specific breakpoints.

  * 'anext' - step past await/yield.

  * Preserve when a variable has been expanded/unexpanded in the debugger.

  * Keep focus on debugger input box whenever possible.

  * Echo stdout/stderr in the Observatory debugger.  Standalone-only so far.

  * Minor fixes to service protocol documentation.

  * **Breaking:** various commands that previously ran `pub get` implicitly no
    longer do so. Instead, they merely check to make sure the ".packages" file
    is newer than the pubspec and the lock file, and fail if it's not.

  * Added support for `--verbosity=error` and `--verbosity=warning`.

  * `pub serve` now collapses multiple GET requests into a single line of
    output. For full output, use `--verbose`.

  * `pub deps` has improved formatting for circular dependencies on the
    entrypoint package.

  * `pub run` and `pub global run`

    * **Breaking:** to match the behavior of the Dart VM, executables no longer
      run in checked mode by default. A `--checked` flag has been added to run
      them in checked mode manually.

    * Faster start time for executables that don't import transformed code.

    * Binstubs for globally-activated executables are now written in the system
      encoding, rather than always in `UTF-8`. To update existing executables,
      run `pub cache repair`.
    * A deadlock caused by declaring transformer followed by a lazy transformer
      (such as the built-in `$dart2js` transformer) has been fixed.

    * A transformer that tries to read a non-existent asset in another package
      will now be re-run if that asset is later created.

### VM Service Protocol Changes

* **BREAKING** The service protocol now sends JSON-RPC 2.0-compatible
  server-to-client events. To reflect this, the service protocol version is
  now 2.0.

* The service protocol now includes a `"jsonrpc"` property in its responses, as
  opposed to `"json-rpc"`.

* The service protocol now properly handles requests with non-string ids.
  Numeric ids are no longer converted to strings, and null ids now don't produce
  a response.

* Some RPCs that didn't include a `"jsonrpc"` property in their responses now
  include one.

  See [dartlang.org/tools](https://www.dartlang.org/tools/) for alternatives.