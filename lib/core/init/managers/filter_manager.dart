class FilterManager {
  static List<Map<String, dynamic>> filterSearchResults({
    required String query,
    required String Function(Map<String, dynamic>) mapName,
    required List<Map<String, dynamic>> originalLIst,
    required List<Map<String, dynamic>> filteredList,
    required Function(void Function()) setState,
  }) {
    List<Map<String, dynamic>> dummySearchList = [];
    dummySearchList.addAll(originalLIst);
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      for (var item in dummySearchList) {
        final String name = mapName(item).toLowerCase();
        if (name
            .replaceAll('ü', 'u')
            .contains(query.toLowerCase().replaceAll('ü', 'u'))) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filteredList.clear();
        filteredList.addAll(dummyListData);
      });
    } else {
      setState(() {
        filteredList.clear();
        filteredList.addAll(originalLIst);
      });
    }
    return filteredList;
  }
}
