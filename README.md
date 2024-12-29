Deployment target: Minimum Target: iOS(16)

Structure:
Used Clean MVVM Architecture consisting of Data, Domain and Presentation Layers.

Network Layer: 
Used URLSession with combine.

Navigation:
Used Coordinator Architecture which uses Navigation Stack in navigation logic.

UI:
SwiftUI

Modules:
CurrenciesList, That shows list of currencies returned from Coin Gecko API.
CurrencyDetails, Navigated to from list by clicking on item list and shows selected item details.

Currencies List Features:
CurrenciesList has auto refresh feature called every 30 seconds in order to refresh currencies periodically.

Search: There is search bar using Coin Gecko API in order to fetch search Keyword results, Using debounce of 700 milliseconds to enable user write the search keyword then search. (Noting that search api isn't returning price so it showed as 0.0).

Add-To-Favorites: User can favorite the desired item and it saved locally using UserDefaults. Also can click on favorites button in order to show all favorites items.
