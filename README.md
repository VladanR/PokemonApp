                                            POKEMON APP
                                            
This is a simple App made to showcase iOS development and Swift skills, built using the Model-View-ViewModel (MVVM) architecture pattern. 
The app utilizes https://pokeapi.co to fetch and display information about Pokémon. It employs URLSession for networking tasks and Kingfisher for image loading and caching.

Implementation Choices:

MVVM Architecture

MVVM was chosen for its separation of concerns and testability. It helps maintain a clean architecture by separating the business logic from the UI components. This separation enables easier unit testing, improves code readability, and makes it easier to manage complex UI interactions.

URLSession for Networking

URLSession is a powerful and flexible API provided by Apple for making network requests. It provides built-in support for tasks like data, download, and upload and features like background sessions, authentication, and caching. URLSession allows for fine-grained control over network requests and responses, enabling efficient data fetching from PokeAPI.

Kingfisher for Image Loading and Caching

Kingfisher is a widely used library for downloading and caching images in iOS apps. It provides convenient methods for asynchronously loading images from URLs, caching them both in memory and on disk, and handling image transformations. By using Kingfisher, the app can efficiently load Pokémon images from PokeAPI and cache them locally, improving performance and reducing data usage.

Features

Display a list of Pokémon with their names and images.

Tap on a Pokémon to view detailed information about it.


