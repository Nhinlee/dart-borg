/*
 * MIT License
 *
 * Copyright (c) 2020 Alexei Sintotski
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:borg/src/configuration/configuration.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import 'options/verbose.dart';
import 'utils/file_finder.dart';

// ignore_for_file: avoid_print

Iterable<String> locatePubspecFiles({
  @required String filename,
  @required BorgConfiguration configuration,
  @required ArgResults argResults,
}) {
  stdout.write('Scanning for $filename files...');
  final pubspecFileLocations = _locationsToScan(filename, configuration);
  print(' ${pubspecFileLocations.length} files found');
  if (getVerboseFlag(argResults)) {
    for (final loc in pubspecFileLocations) {
      print('\t$loc');
    }
  }

  if (pubspecFileLocations.isEmpty) {
    print('\nWARNING: No configuration files selected for analysis');
    exit(2);
  }

  return pubspecFileLocations;
}

Iterable<String> _locationsToScan(String filename, BorgConfiguration config) {
  final fileFinder = FileFinder(filename);
  final includedLocations = fileFinder.findFiles(config.pathsToScan);
  final excludedLocations = fileFinder.findFiles(config.excludedPaths);
  return includedLocations.where((location) => !excludedLocations.contains(location)).map(path.relative);
}
