# YouTube Channel Finder 🎥

A browser extension that allows users to quickly search for YouTube channels and view their statistics. Built with Ruby (Sinatra) backend and JavaScript frontend.

## 🌟 Features

- 🔍 Search YouTube channels by name
- 📊 View real-time statistics:
  - Subscriber count
  - Total video count
  - View counts
- 🖼️ Channel thumbnails and descriptions
- 🔗 Direct links to YouTube channels
- 💨 Fast and lightweight
- 🎨 Clean, user-friendly interface

## 🚀 Installation

### Backend Setup

1. Clone the repository:

```bash
git clone https://github.com/[your-username]/youtube-channel-finder.git
cd youtube-channel-finder
```

2. Install dependencies:

```bash
bundle install
```


3. Create a `.env` file in the root directory:

```bash
touch .env
```

4. Add your YouTube API key to the `.env` file:

```bash
YOUTUBE_API_KEY=your_youtube_api_key_here
```
5. Start the server:

```bash
ruby app.rb
```

The server will start at `http://localhost:4567`

### Extension Setup

1. Open Microsoft Edge browser
2. Navigate to `edge://extensions/`
3. Enable "Developer mode" in the top right
4. Click "Load unpacked"
5. Select the `extension` folder from this repository

## 🛠️ Tech Stack

- **Backend:**
  - Ruby 3.0+
  - Sinatra (Web Framework)
  - REST-Client (API calls)
  - Dotenv (Environment management)

- **Frontend:**
  - HTML5
  - CSS3
  - JavaScript (ES6+)
  - Chrome Extension APIs

- **APIs:**
  - YouTube Data API v3

## 📁 Project Structure

- `app.rb`: Main application file, handles API requests and responses
- `extension`: Folder containing the browser extension code
- `Gemfile`: Bundler configuration file
- `.env`: Environment variables file
- `.gitignore`: Git ignore file
- `README.md`: This README file

youtube-channel-finder/
├── app.rb # Main Sinatra application
├── config.ru # Rack configuration
├── Gemfile # Ruby dependencies
├── .env # Environment variables (git-ignored)
├── extension/
│ ├── manifest.json # Extension configuration
│ ├── popup.html # Extension popup interface
│ ├── popup.js # Extension JavaScript
│ └── icons/ # Extension icons
└── README.md # This file


## 🔧 Configuration

### Getting a YouTube API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project
3. Enable the YouTube Data API v3
4. Create credentials (API Key)
5. Add the API key to your `.env` file


