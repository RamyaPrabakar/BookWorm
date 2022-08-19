Original App Design Project - README
===

# BookWorm

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)

## Overview
### Description
BookWorm is a book recommendation and reviewing app that allows users to customize their book reading experience. The app also has a chat feature that allows users to interact with each other and form groups to discuss the books that they are reading (sort of like a bookclub!).

### App Evaluation

- **Category:** Education / Entertainment
- **Mobile:** The app uses the camera to take pictures of books that users have read when they make posts. This is a uniquely mobile experience.
- **Story:** I think that this app has a really compelling story around it, especially for avid book readers. It gives book suggestions according to user preference and also helps users for a community of fellow book worms
- **Market:** There is a well defined audience for this app (book readers). The size of the user base is pretty large. It will target book enthusiasts of all ages.
- **Habit:** An average user both consumes and creates on this app. I think that an average user would use this app whenever they need book recommendations. They will also check the app often to check on their book club and their book reading friends.
- **Scope:** I think that this app will be pretty technically challenging to complete. I need to build a whole chat service in the app to enable users to talk to each other. But, even if I am not able to complete all the features that I would like to, the stripped down version of this app is still interesting to implement and use.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create a new account
* User can login
* Users can choose their prefered genres for book suggestions
* Users can edit their profile and add their bio and other information
* User can chat with other users and form chat groups (book clubs)
* Users can friend and unfriend other users
* Users can mark books as "To read", "Reading" and "Read"
* Users can rate and comment on books
* Users can see a detailed view of the books that they click on
* Users can search for specific books

**Optional Nice-to-have Stories**

* Users can make posts about the books that they have read
* Other users can like and comment on these book posts
* User profile has statistics of the user's book reading experience (number of books completed, number of friends, etc..)
* Detailed view of a book links to an amazon link to purchase that book

### 2. Screen Archetypes

* Login screen
   * User can login
   
* Sign up screen
   * User can create a new account and sign up
   
* Genre picking screen
   * User can pick the genres that they like
   
* Recommendation screen
   * Gives us book recommendations from the users preferred genres
   * The book recommendations are ordered based on their ratings (from) highest rating to lower ratings
   * Users can rate books
   
* My books screen
   * Gives the books that the logged in user wants to read, is reading and has read
   
* Posts screen
   * Posts from different users about their book reading journey (finishing a book, finding a book that they really like etc.)
   
* Explore screen
   * Can search for other users based on username / name
   * Can search for books based on book name, ISBN
   
* Messages screen
   * Shows a user all the private messages and message groups they have
   
* Specific Chat screen
  * Shows the specific priavte message or message group that they clicked on
  
* Profile screen
   * Gives us information about the logged in user when we click on the profile icon
   
* Detail book screen
   * Gives us more details about the clicked book
   * Gives us the synopsis of the book, the reviews for the book, user's comments about the book

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Recommendations tab
* My books tab
* Posts tab
* Explore tab
* Book talk tab - Messages tab

**Flow Navigation** (Screen to Screen)

* Login Screen
   => Recommendations screen
* Sign up screen
   => Genre picker screen
*  Genre picker screen
   => Recommendations screen
* Recommendations screen
   => Details screen (when a book is clicked)
   => Profile screen (when the profile icon is clicked)
* Messages screen
   => Specific chat screen

## Wireframes![](https://i.imgur.com/HGKJeAH.png)
