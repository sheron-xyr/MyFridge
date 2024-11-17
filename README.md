# MyFridge
This is an iOS application used for supervising household food materials. It can highlight the food materials that are nearing their expiration dates and provide nutritional information of the food materials, helping users avoid food waste and achieve a healthier diet.

<video src="https://github.com/user-attachments/assets/14a9a356-099f-49ca-ac4b-ebd572b08729" height="400"></video>





## Features

### Home Page

- [x] Navigation to the three main pages: Food List Page, Recipe List Page, and Settings Page.
- [ ] Log in function.

### Settings Page

- [ ] User preferences
  - [x] The number of days for some food material to be considered as near expiration.
  - [x] The types of nutrition information to display.
  - [ ] The types of preferred recipes.
- [ ] Account
  - [ ] Username
  - [ ] Password

### Food List Page

- [x] Sorting (by expiration date or food name) and searching (by food name).
- [x] List of food materials available at home.
  - [x] Important information shown on the list page: image, name, days until expiration (red if near expiration; black otherwise), and quantity.
  - [x] Detail page by clicking this food item: more information including nutrition, and allowance for editing quantity and expiration date.
- [x] Add food button navigating to add food page.
  - [x] Manually entering food information.
  - [x] Image recognition and text recognition.
  - [x] Getting nutrition information with API before addition.
  - [x] An alert for successful addition.

### Recipe List Page

- [x] Filtering (by favorited or not) and searching (by recipe name).
- [x] List of recipes.
  - [x] Detail page by clicking this recipe item: more information including nutrition, and allowance for favorite this recipe.
- [ ] Add recipe button navigating to add recipe page.
  - [x] Manually entering recipe information.
  - [ ] Searching online recipes and importing them. 
  - [x] An alert for successful addition.

## Requirements

- iOS 17.0+
- Xcode 16.0

## Installation

1. Click on the green "Code" button and select "Download ZIP" to download the project files to your local computer.
2. Unzip the ZIP file and use Xcode to open the unzipped folder.
3. Connect your iOS device to the computer using a USB cable, and select this device as the destination.
4. Click run. Note that some permissions may be needed, so just follow the instructions popped up.

## Future Directions for Developers

- Some functions have not been implemented yet, as shown in the **Features** section (the unfilled checkboxes).
- Currently, the image recognition and text recognition functions are implemented by the built-in models of Apple Vision. As a result, the recognition rates are relatively low, especially for image recognition. More targeted models can be used instead.
- Recommend healthy recipes based on the existing food materials, especially those that are nearing their expiration dates.
