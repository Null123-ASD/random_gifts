# Now let me briefly introduce the technical architecture and highlights of this application.


# Technical architecture:
# The application is developed using the Flutter framework to achieve cross-platform operation and support Android and iOS.

# SQLite is used for data storage to ensure that the gift data added by users is permanently saved and supports local retrieval and management.

# Images are stored on local devices, reducing reliance on the network and improving loading speed and user experience.

# Integrates the ChatGPT API, which handles chat functionality and returns real-time responses through Web API requests.


# Technical highlights:
# Random gift function: Combined with random data query of SQLite database, it can realize fast and non-duplicate gift recommendation.

# User-defined functions: Visual CRUD operations (create, delete, modify and query) provide users with high flexibility.

# Chatbox integration: Real-time interaction makes the application more intelligent and interesting.


firebase storage => future

I originally wanted to use Firebase for cross-data, but uploading pictures to Firebase Storage requires payment, so it was not possible.
Therefore, in future development, we can develop this aspect. Furthermore, you can cooperate with brand merchants to attract users to buy.

