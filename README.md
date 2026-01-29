# 🎲 D&D Companion Mobile Application

A comprehensive iOS mobile application designed to enhance the Dungeons & Dragons tabletop gaming experience by centralizing essential gameplay tools into a single, user-friendly platform.

## 📖 Overview

Dungeons & Dragons players often need to consult multiple resources during gameplay—rulebooks, character sheets, spell lists, and campaign notes—which can interrupt immersion and slow down sessions. This application addresses these pain points by providing quick access to frequently used data and automating character-related updates.

## ✨ Key Features

### 🔐 User Authentication & Account Management
- Secure login and signup functionality
- Password reset support
- Firebase-powered authentication system

### 👤 Character Creation & Management
- Guided character creation process
- Comprehensive character overview (stats, equipment, spells, progression)
- Dynamic character modification as campaigns evolve

### 📚 Spell, Item & Bestiary Lookup
- Searchable databases for spells, items, and creatures
- Detailed views with descriptions, effects, and attributes
- Quick reference during gameplay

### ⚔️ Character-Specific Management
- Add/remove spells assigned to characters
- Inventory management system
- Track and swap attuned items

### 🛠️ Homebrew Content Support
- Create custom spells and items
- Character-linked homebrew content
- Campaign customization flexibility

### 📝 Campaign Notes & Quest Tracking
- Campaign note-taking system for players and DMs
- Quest log for tracking objectives and progress
- Interactive map feature for visualizing campaign locations

### ☁️ Data Persistence & Synchronization
- Cloud-based storage via Firebase
- Real-time synchronization across devices
- Secure and reliable data persistence

## 🏗️ Tech Stack

### Frontend
- **Swift/SwiftUI** - Native iOS interface and user interactions
- **MapKit** - Interactive map features
- **CoreData** - Local persistent storage for offline access

### Backend
- **Python (FastAPI)** - RESTful API development
- **Firebase Authentication** - User management
- **Firebase Firestore** - Cloud database

### API & Data
- RESTful APIs with JSON format
- Data sourced from GitHub repository
- Python backend for data fetching and parsing

## 🏛️ Architecture

The application follows the **MVVM (Model-View-ViewModel)** architectural pattern, ensuring:
- Clear separation of concerns
- Improved code organization and maintainability
- Scalability for future features
- Layered structure for presentation, networking, and data persistence

## 🎯 Target Users

### Primary Users
- **D&D Players** - Manage characters, lookup rules, track progress

## 🛠️ Development Tools

- **Xcode** - iOS development and debugging
- **Visual Studio Code** - Python backend development
- **Git & GitHub** - Version control and collaboration
- **Postman** - API testing and documentation
- **Firebase Console** - Authentication and database management

## 📱 Features in Detail

### Character Management
- Level progression tracking
- Ability score management
- Hit points and temporary HP
- Spell slot tracking
- Equipment and inventory

### Spell Management
- Spell preparation tracking
- Spell slot usage
- Filtering by class, level, and school
- Detailed spell descriptions

### Campaign Tools
- Session notes
- NPC tracking
- Location mapping
- Quest objectives and rewards

## 🔒 Security

- Secure authentication via Firebase
- Encrypted data transmission
- User data isolation
- Secure API endpoints

## 🙏 Acknowledgments

- D&D 5e SRD for game data
- The D&D community for inspiration and feedback
- Open-source contributors

## 📧 Contact

Project Link: [https://github.com/yourusername/dnd-companion-app](https://github.com/yourusername/dnd-companion-app)

**Note:** Dungeons & Dragons and D&D are trademarks of Wizards of the Coast LLC. This application is not affiliated with or endorsed by Wizards of the Coast.
