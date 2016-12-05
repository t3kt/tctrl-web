// Copyright (c) 2016, tekt. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';

import 'package:tctrl/app_component.dart';

import 'package:tctrl/nexus/nexus.dart';
import 'package:tctrl/nexus/nexus_adapter.dart' as nexus;

main() {
  bootstrap(AppComponent, [
    nexus.bindings,
  ]);

  var nx = globalInstance;
  print('OMG NX! $nx');
  nx.addWidget('dial');
  nx.addWidget('colors');
}
