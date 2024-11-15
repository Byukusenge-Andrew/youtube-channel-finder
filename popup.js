document.getElementById('searchButton').addEventListener('click', async () => {
    const query = document.getElementById('searchInput').value;
    const results = document.getElementById('results');
    
    if (!query.trim()) {
      showError('Please enter a channel name');
      return;
    }
  
    showLoading();
  
    try {
      const response = await fetch(`http://localhost:4567/search?query=${encodeURIComponent(query)}`);
      const data = await response.json();
      
      if (data.error) {
        showError(data.error);
        return;
      }
      if (!Array.isArray(data)) {
        showError('Invalid response from server');
        return;
      }
      
      if (data.length === 0) {
        showError('No channels found');
        return;
      }
  
      displayResults(data);
    } catch (error) {
      showError('Failed to connect to server');
      console.error(error);
    }
  });
  
  function showLoading() {
    const results = document.getElementById('results');
    results.innerHTML = `
      <div class="loading">
        <div class="spinner"></div>
        <p>Searching YouTube channels...</p>
      </div>
    `;
  }
  
  function showError(message) {
    const results = document.getElementById('results');
    results.innerHTML = `
      <div class="error">
        <span class="error-icon">!</span>
        <span class="error-message">${message}</span>
      </div>
    `;
  }
  
  function displayResults(channels) {
    const results = document.getElementById('results');
    if (!channels || channels.length === 0) {
      showError('No channels found');
      return;
    }
    
    results.innerHTML = channels.map(channel => `
      <div class="channel">
        <img src="${channel.thumbnail}" alt="${channel.title}">
        <div class="channel-info">
          <h3>${channel.title}</h3>
          <p class="stats">
            ${formatNumber(channel.subscribers)} subscribers • 
            ${formatNumber(channel.video_count)} videos
          </p>
          <a href="https://youtube.com/channel/${channel.channel_id}" target="_blank">Visit Channel</a>
        </div>
      </div>
    `).join('');
  }  
  function formatNumber(num) {
    if (num >= 1000000000) {
      return (num / 1000000000).toFixed(1) + 'B';
    }
    if (num >= 1000000) {
      return (num / 1000000).toFixed(1) + 'M';
    }
    if (num >= 1000) {
      return (num / 1000).toFixed(1) + 'K';
    }
    return num.toString();
  }
  document.getElementById('searchInput').focus();