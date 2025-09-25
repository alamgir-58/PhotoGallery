# 📱 Photo Gallery App – SwiftUI

## 📌 Overview

This is a simple iOS photo gallery application built using **SwiftUI**.  
The app fetches and displays a collection of photos from the [Picsum API](https://picsum.photos/).  
Users can view photos in a grid layout, tap any photo to open it in a full-screen view, and pinch-to-zoom in or out.

---

## 🛠️ Core Features

- 📷 **Photo Grid View** – Displays a collection of photos using SwiftUI’s `LazyVGrid`.  
- 🔍 **Full-Screen Photo View** – Opens a photo in full screen when tapped.  
- 🤏 **Pinch-to-Zoom** – Supports zooming in and out in full-screen mode.  
- 🌐 **Network Layer with URLSession** – Fetches images from the Picsum API.  
- 🔄 **Combine Framework** – Handles asynchronous data loading and reactive updates.  
- 🛡️ **Bug-Free & Crash-Free** – Smooth performance ensured.

---

## 🚀 Optional Enhancements

- 🧪 Unit tests for view models and network layer.  
- 📁 Image caching to improve performance.  
- 📦 API response caching.  
- 💾 Save photos to the device gallery.  
- 📤 Photo sharing feature.

---

## 📦 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/alamgir-58/PhotoGallery.git

2. Open the project in Xcode:
    ```bash
   cd PhotoGallery
    open PhotoGallery.xcodeproj
    
3. Build and run on Simulator or Device.

---

## 🧪 API Reference

We are using the free Picsum API to fetch random images.

- Example: https://picsum.photos/v2/list?page=1&limit=100

