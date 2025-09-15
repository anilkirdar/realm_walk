// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:implementation_imports, file_names, unnecessary_new
// ignore_for_file:unnecessary_brace_in_string_interps, directives_ordering
// ignore_for_file:argument_type_not_assignable, invalid_assignment
// ignore_for_file:prefer_single_quotes, prefer_generic_function_type_aliases
// ignore_for_file:comment_references

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_ar.dart' as messages_ar;
import 'messages_az.dart' as messages_az;
import 'messages_bg.dart' as messages_bg;
import 'messages_bn.dart' as messages_bn;
import 'messages_cs.dart' as messages_cs;
import 'messages_en.dart' as messages_en;
import 'messages_es.dart' as messages_es;
import 'messages_fa.dart' as messages_fa;
import 'messages_gn.dart' as messages_gn;
import 'messages_hu.dart' as messages_hu;
import 'messages_hy.dart' as messages_hy;
import 'messages_id.dart' as messages_id;
import 'messages_ja.dart' as messages_ja;
import 'messages_ka.dart' as messages_ka;
import 'messages_kk.dart' as messages_kk;
import 'messages_ko.dart' as messages_ko;
import 'messages_lt.dart' as messages_lt;
import 'messages_mn.dart' as messages_mn;
import 'messages_ms.dart' as messages_ms;
import 'messages_ne.dart' as messages_ne;
import 'messages_pl.dart' as messages_pl;
import 'messages_pt.dart' as messages_pt;
import 'messages_ro.dart' as messages_ro;
import 'messages_ru.dart' as messages_ru;
import 'messages_sg.dart' as messages_sg;
import 'messages_sw.dart' as messages_sw;
import 'messages_te.dart' as messages_te;
import 'messages_th.dart' as messages_th;
import 'messages_tl.dart' as messages_tl;
import 'messages_tr.dart' as messages_tr;
import 'messages_ur.dart' as messages_ur;
import 'messages_uz.dart' as messages_uz;
import 'messages_vi.dart' as messages_vi;
import 'messages_zu.dart' as messages_zu;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'ar': () => new SynchronousFuture(null),
  'az': () => new SynchronousFuture(null),
  'bg': () => new SynchronousFuture(null),
  'bn': () => new SynchronousFuture(null),
  'cs': () => new SynchronousFuture(null),
  'en': () => new SynchronousFuture(null),
  'es': () => new SynchronousFuture(null),
  'fa': () => new SynchronousFuture(null),
  'gn': () => new SynchronousFuture(null),
  'hu': () => new SynchronousFuture(null),
  'hy': () => new SynchronousFuture(null),
  'id': () => new SynchronousFuture(null),
  'ja': () => new SynchronousFuture(null),
  'ka': () => new SynchronousFuture(null),
  'kk': () => new SynchronousFuture(null),
  'ko': () => new SynchronousFuture(null),
  'lt': () => new SynchronousFuture(null),
  'mn': () => new SynchronousFuture(null),
  'ms': () => new SynchronousFuture(null),
  'ne': () => new SynchronousFuture(null),
  'pl': () => new SynchronousFuture(null),
  'pt': () => new SynchronousFuture(null),
  'ro': () => new SynchronousFuture(null),
  'ru': () => new SynchronousFuture(null),
  'sg': () => new SynchronousFuture(null),
  'sw': () => new SynchronousFuture(null),
  'te': () => new SynchronousFuture(null),
  'th': () => new SynchronousFuture(null),
  'tl': () => new SynchronousFuture(null),
  'tr': () => new SynchronousFuture(null),
  'ur': () => new SynchronousFuture(null),
  'uz': () => new SynchronousFuture(null),
  'vi': () => new SynchronousFuture(null),
  'zu': () => new SynchronousFuture(null),
};

MessageLookupByLibrary? _findExact(String localeName) {
  switch (localeName) {
    case 'ar':
      return messages_ar.messages;
    case 'az':
      return messages_az.messages;
    case 'bg':
      return messages_bg.messages;
    case 'bn':
      return messages_bn.messages;
    case 'cs':
      return messages_cs.messages;
    case 'en':
      return messages_en.messages;
    case 'es':
      return messages_es.messages;
    case 'fa':
      return messages_fa.messages;
    case 'gn':
      return messages_gn.messages;
    case 'hu':
      return messages_hu.messages;
    case 'hy':
      return messages_hy.messages;
    case 'id':
      return messages_id.messages;
    case 'ja':
      return messages_ja.messages;
    case 'ka':
      return messages_ka.messages;
    case 'kk':
      return messages_kk.messages;
    case 'ko':
      return messages_ko.messages;
    case 'lt':
      return messages_lt.messages;
    case 'mn':
      return messages_mn.messages;
    case 'ms':
      return messages_ms.messages;
    case 'ne':
      return messages_ne.messages;
    case 'pl':
      return messages_pl.messages;
    case 'pt':
      return messages_pt.messages;
    case 'ro':
      return messages_ro.messages;
    case 'ru':
      return messages_ru.messages;
    case 'sg':
      return messages_sg.messages;
    case 'sw':
      return messages_sw.messages;
    case 'te':
      return messages_te.messages;
    case 'th':
      return messages_th.messages;
    case 'tl':
      return messages_tl.messages;
    case 'tr':
      return messages_tr.messages;
    case 'ur':
      return messages_ur.messages;
    case 'uz':
      return messages_uz.messages;
    case 'vi':
      return messages_vi.messages;
    case 'zu':
      return messages_zu.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) {
  var availableLocale = Intl.verifiedLocale(
    localeName,
    (locale) => _deferredLibraries[locale] != null,
    onFailure: (_) => null,
  );
  if (availableLocale == null) {
    return new SynchronousFuture(false);
  }
  var lib = _deferredLibraries[availableLocale];
  lib == null ? new SynchronousFuture(false) : lib();
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new SynchronousFuture(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
  var actualLocale = Intl.verifiedLocale(
    locale,
    _messagesExistFor,
    onFailure: (_) => null,
  );
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
