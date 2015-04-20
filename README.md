# pretty_samples

Prettify code samples in HTML files using [Javascript code prettifier][prettyprint] in AngularDart apps.

This library could be used with [DaCSS Presentation Library][dacsslide]

## Demo 

[Demo][demo] is built version of [example][example]` folder.

## Usage

Check `example` folder. 

Add `SamplesModule`:

    import 'package:angular/application_factory.dart';
    import 'package:pretty_samples/dacss_samples.dart';

    main() {
           applicationFactory().addModule(new SamplesModule()).run();
    }

After that you can add `sample` attribute to any `HTML` element, like

    <div sample='some-sample.html`></div>
    
Module will download `some-sample.html` content, prettify it and put into div.

You can also reference samples inside same document by IDs:

    <div sample='#someId'></div>
    <div id="#sampleId" style="display:none"></div>
   

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/olostan/pretty_samples/issuess
[dacsslide]: https://github.com/olostan/dacsslide
[prettyprint]: https://google-code-prettify.googlecode.com/svn/trunk/README.html
[demo]: http://olostan.github.io/pretty_samples/
[example]: https://github.com/olostan/pretty_samples/tree/master/example

