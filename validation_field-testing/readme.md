# Validation Field Testing

Determining conformance of OSCAL schemas to their Metaschema definitions.

More generally this means determining conformance of any generated or acquired schemas to Metaschema semantics.


## tl/dr

### Acquire Morgana XProc III engine

This is easiest with `bash`. Under Windows, a generic WSL should work (Ubuntu has been tested) or a Windows `bash` application such as Git Bash.

Currently this is the only bash dependency; everything else requires only Java plus the downloaded software.

From a `bash` prompt, run the script

```
> acquire-morgana.sh
```

It downloads Morgana and Saxon into `lib` and unzips them.

We ask you to do this for us (rather than copying the distribution into the repository) because we wish to stress the contribution of the XProc 3 processor (Morgana XProc III) along with its own dependency stack including the **Saxon** processor.

Details on script operation are given in [Installing Morgana](#installing-morgana) below.

### Test run Morgana

Smoke test your Morgana installation by running a test pipeline:

On Windows

```
> .\xproc3 XPROC3-SMOKETEST.xp3
```

invokes the script `run-morgana.bat`

On Linux

```
> ./xproc3.sh XPROC3-SMOKETEST.xp3
```

Either script should run the Morgana XProc 3 engine to produce a pretty XML file.

If a script errors, check its paths and settings (are they up to date with what you installed?) before retracing your steps.

#### Drag-and-drop runtime

Those who prefer mouse swipes to command lines can run an XProc 3 pipeline using the Windows GUI:

- Create a desktop shortcut to `xproc3.bat`
- Drag any pipeline `ALLCAPS.xp3` onto the icon to run it.

The naming convention `ALLCAPS.xp3` is used in this project for XProc 3 pipeline files that are designed to run standalone in place, with no external ports or special runtime configuration. (These may work by calling other XProc files that are not so insulated.) Since invoking these is simple it is also easy to instrument.

TODO: see to it that this works also with `xproc3.sh` on GUIs with `bash` support.

### Run the XSD field tests

Use the pipeline, Luke!

### Run the JSON validator field tests

### Inspect and assess the test samples

### Add to the test samples

#### Converting valid samples

#### Reproducing invalid samples

## What are we testing?

A schema must be tested in a validating processor (depending on the kind of schema), but they can also be decoupled by "mixing and matching" schemas in standard syntaxes with engines that implement them.

Three different outputs of a schema validation process might be considered:

- Validity state as an abstraction - typically a Boolean value ('valid' or 'not valid')
- Validation messages - all messages or any 'validation' messages delivered by a processor
-   typically excluding info level messages
-   typically including 'error' and 'warning' level messages
- Post-validation document, as amended
  - In XSD this would be a PSVI

Largely since we need to support both JSON Schema and XML validations with a wide range of processors, we support only the *first level* of testing here.

We do this by provided sets of known-valid and known-invalid inputs, and aligning tests to see if a validator (schema+processor combination) gives the expected results when run over those inputs.

However, Metaschema technology goes beyond this first level, and since different validators may support different subsets of the full range of tests implied by a metaschema, further discriminations are necessary.

Accordingly we start with (at least) three categories:

- `valid` - XSD and JSON-Schema level structural validation + constraints validation (no messages more severe than 'warning')
- `defective` - violates a modeling rule (detectable by XSD or JSON Schema)
- `disordered` - violates a metaschema-defined constraint (not detectable by XSD or JSON Schema)
- (possibly for later) `variant` - violates 'WARNING' level constraints only

Running over these sets, a validation engine is expected to be able to discriminate their members correctly, to the extent possible. Without support for Metaschema constraints, an XSD or JSON Schema validator cannot distinguish between 'valid' and 'disordered' - for them, a putative category 'schema-valid' unifies `valid` and `disordered`.

(A different intersection, namely instances that return no errors on constraints but are invalid structurally, is excluded, since structural validation is a *sine qua non*. Only instances that are not defective can be disordered.)

We have to maintain all categories in both XML and JSON formats, to begin (possibly YAML also, in future).

A small but pervasive problem in JSON Schema modeling provides us an opportunity to use this scaffolding.

## Setup and refresh

### Set up Morgana XProc III

To download and install Morgana, users of `bash` can run the script: `acquire-morgana.sh`.

It downloads Morgana into `lib` and unzips it. Then it downloads the Saxon XSLT engine and copies its Java runtime `jar` into the Morgana distribution for use with Morgana.

This can be done by hand on systems with no `bash` shell:

- Morgana can be downloaded from  https://sourceforge.net/projects/morganaxproc-iiise/files
  - Get the latest `.zip`, don't worry about source code
- Download Saxon at https://www.saxonica.com/download/SaxonHE12-4J.zip (or adjust for version)
  - Unzip and copy `saxon-he-12.4.jar` into the new `MorganaXProc-IIIse-{version}/MorganaXProc-IIIse_lib`
  - Discard the rest as unneeded

The authors and contributors to Saxon and Morgana starting with Michael Kay (Saxon), Achim Berndzen (Morgana) and Norman Walsh and the XProc community (XProc) are owed acknowledgement for making this possible.

### Refresh schemas and converters

OSCAL catalog schemas (XSD and JSON Schema) should be downloaded into the `lib` directory.

Additionally, converter XSLTs for the verson of OSCAL can be very useful for aligning JSON and XML versions of the samples.

Scripts `refresh-catalog-schemas.sh` and `refresh-catalog-converters.sh` perform these updates from the OSCAL repository.

### Configuration

By and large, the runtimes work by invoking an XML pipelining engine (Calabash or Morgana) or transformation engine (Saxon). These expect specified inputs to be in place, typically as defined by the pipeline step definition - i.e. the XProc (\*.xpr or \*.xp3) or XSLT (\*.xsl) named in the script.

For example [tbd]

Pointers for schemas (XSD or JSON Schema)

Pointers for documents

### Runtimes

`bash` and Windows scripts invoke processes in Maven or Java

They deliver results to the console, and may also write files to the system.

`xsd-fieldtest.sh` - `xsd-fieldtest.bat` - invoke Maven to run tests on provided XSD Schema, testing it on XML reference set
`jsv7-fieldtest.sh` - `jsv7-fieldtest.bat` - invoke Maven to run tests on provided JSON Schema (v7), testing it on JSON reference set

#### Utilities

(tbd)

`xml-to-json.sh` convert an OSCAL XML Catalog into JSON
`json-to-xml.sh` convert an OSCAL JSON Catalog into XML

## Resources

The architecture and configuration are intended to be appropriated and embedded in tests for other schema validators.

- Batch and shell scripts in this folder (\*.bat and \*.sh) - top-level runtimes for Bash or Windows (qv)
- `lib` includes downloaded resources, including
  - schemas to be tested
  - MorganaXProcIII Java library (XProc III processor supporting JSON Schema)
- `reference-set`
  - `xml` and `json` each containing
     - `fully-valid` - aka `valid` (see above)
     - `schema-invalid` (aka `defective`)
     - `constraints-invalid` (not `defective` but `disordered`) - nb, empty for now pending work on constraints testing
   - For testing an XSD or JSON Schema, we detect `schema-invalid` and consider the others valid
   - For testing an implementation of Metaschema constraints, we detect all three categories
- `src` XSLT and XProc code supporting runtimes
  - `\*.xpr` signifies XProc 1.0 (for XML Calabash)
  - `\*.xp3` signifies XProc 3.0 (for Morgana XProc III)

## Goals

We aim to be able to show definitively that a particular XSD or JSON schema is capable of discriminating correctly between valid and invalid documents, across a set of known (controlled and well understood) instances.

This is in support of OSCAL Issue https://github.com/usnistgov/OSCAL/issues/1989 and related issues.

Going beyond this to address more pervasive problems, we aim to be able to test any XSD or JSON Schema, with any schema validation engine. Similarly, any validator that 'emulates' a schema (returns the same error messages as a schema validation would, for the same inputs) can similarly be tested.

For this prototype we focus on the processors built into commodity XML tools as a baseline: XSD and JSON Schema validation as offered by XML Calabash (an XProc 1.0 engine supporting rudimentary 'black box' XSD 1.0 validation) and by Morgana XProc III (for JSON Schema).

## Non-goals

We have longer term goals also, but some of this work must be postponed.

To support generalizing the approach, an interface language for validation error reporting must be designed and deployed. This is not part of the current scope of work, but should be planned (in the [Metaschema]() context, not OSCAL context). Until then, each new validation engine must be provided with its own testing harness.


## TODO

Morgana installation
  .sh executing curl
  .bat equivalent

Top-level scripts to call Morgana
  .sh calling lib/Morgana/Morgana.sh
  .bat calling lib/Morgana/Morgana.sh
  Instructions how to use
    from CL
    drag and drop (Windows; *nix and Mac equivalent?)

XProc3 pipelines
  XSD field testing
  Converters
  JSON Schema field testing

Samples



/bin stuff for Make and scripting support?

XSD batch validation runtime (XProc1 + mvn)
Batch XML->JSON converter runtime ()
JSON batch validation runtime
scripts
  resources update
  run process

drag and drop XProc execution?




XProc for updating resources
XProc for installing Morgana?

