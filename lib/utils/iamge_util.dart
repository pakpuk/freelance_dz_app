// READ ONLY: do not modify this file.

// Retrieves a random image by keyword from Unsplash
// Keyword must be a single word STRING LITERAL (not variable), such as "Peace Lily" "Niagara Falls" "Poodle". Be specific about the keyword and add a generic category.
// imageType must be one of "photo", "illustration" or "vector"
// category can be "backgrounds", "fashion", "nature", "science", "education", "feelings", "health", "people", "religion", "places", "animals", "industry", "computer", "food", "sports", "transportation", "travel", "buildings", "business" or "music"
// colors can be one of the following values: "grayscale", "transparent", "red", "orange", "yellow", "green", "turquoise", "blue", "lilac", "pink", "white", "gray", "black" or "brown"
String getRandomImageByKeyword(
  String keyword, {
  String imageType = "photo",
  String? category,
  String? colors,
}) {
  return 'https://source.unsplash.com/random?$keyword';
}
