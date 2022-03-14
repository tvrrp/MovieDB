# MovieDB
A simple application that displays movies from a MovieDB API

![alt tag](https://github.com/tvrrp/MovieDB/blob/main/Untitled.png)

## Introduction

The application retrieves information about popular movies using the MovieDB API. Clicking on a movie opens a detailed screen with information about the movie.
You can like movies and then view all liked movies in the Liked tab

## Details

### Deployment Target: 
iOS 13, Project without Storyboard and Xibs, only layout with code

### Architecture
<br>

**MVVM + Coordinators + Services (Core Data Stack + URLSession)**.<br>

### Features
- CollectionView for list of moview
- CollectionView prefetching
- Image loading with Nuke
- CoreData caching for liked movies
