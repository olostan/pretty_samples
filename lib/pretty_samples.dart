// Copyright (c) 2015, Valentyn Shybanov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The pretty_samples library.
///
/// This is an library for Pretty Samples.
library pretty_samples;

import "package:angular/angular.dart";
import "dart:html";
import "dart:async" show Future, Completer;

import "dart:convert" show HtmlEscape;
import "dart:js" show context;

@Injectable()
class PrettifyService {
  Completer _loaded = new Completer();
  PrettifyService() {
    var script = new ScriptElement();
    script.src = 'packages/pretty_samples/prettify/prettify.js';
    script.type = 'text/javascript';
    script.onLoad.listen((event) {
      _loaded.complete();
    });
    document.body.append(script);

    var css = new LinkElement();
    css.href = 'packages/pretty_samples/prettify/sons-of-obsidian.css';
    css.type = 'type="text/css"';
    css.rel = 'stylesheet';
    document.head.append(css);
  }

  Future ensureLoaded() => _loaded.future;
}

@Decorator(selector:'[sample]')
class Sample implements AttachAware{
  Element _element;
  Http _http;
  PrettifyService _service;

  Sample(this._element, this._http, this._service);
  var sanitizer = const HtmlEscape();

  Future<String> getFromDOM(String id) {
    var sample = document.querySelector(id);
    if (sample==null) throw ("Sample $id was not found!");
    return new Future<String>.value(sample.innerHtml);
  }
  Future<String> getSample(String id) {
    return _http.get(id).then((r)=> r.data).catchError((e)  {
      print("Can't load $id");
      return "";
    });
  }
  String sampleId;
  void attach() {
    sampleId = _element.attributes['sample'];
    (sampleId[0]=='#'?getFromDOM(sampleId):getSample(sampleId))
    .then(_setSample);
  }

  _setSample(String sample) async {
    sample  = sanitizer.convert(sample);
    var type = 'html';
    var extensionIdx = sampleId.lastIndexOf('.');
    var sId = sampleId; // some hack for dart2js (substring error)

    if (extensionIdx>-1) {
      type = sId.substring(extensionIdx);
    } 
    if (type == "daart") type = "dart";
    await _service.ensureLoaded();
    sample =  context.callMethod('prettyPrintOne', [sample,type]);
    sample = '<pre class="prettyprint">$sample</pre>';
    _element.innerHtml = sample;
  }
}

class SamplesModule extends Module {
  SamplesModule() {
    bind(PrettifyService);
    bind(Sample);
  }
}