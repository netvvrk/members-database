
const debounce = (callback, wait) => {
    let timeoutId = null;
    return (...args) => {
        window.clearTimeout(timeoutId);
        timeoutId = window.setTimeout(() => {
        callback(...args);
        }, wait);
    };
}

const ACCESS_TOKEN = 'pk.eyJ1IjoiYXJ0dnZyayIsImEiOiJjbHVhamUwaXYwa3A5Mm5tbjl0NzVzNm8xIn0.rNKpX9tfmBsMEPPxe3LTBg';
const API_URL = 'https://api.mapbox.com/search/searchbox/v1/suggest?types=region%2Cdistrict%2Clocality%2Cplace%2Cpostcode'

const autofillEl = document.getElementById("location-search")

const suggestionEl = document.getElementById("suggestion-container")

const locationHiddenEl = document.getElementById("location-hidden")

async function fetchSuggestions(e) {
    const value = e.target.value
    const sessionToken = crypto.randomUUID()

    const response = await fetch(`${API_URL}&access_token=${ACCESS_TOKEN}&session_token=${sessionToken}&q=${value}`)
    const json = await response.json()
    const lineItems = json?.suggestions ?  json.suggestions.map((suggestion, i) =>
     `<li data-place-name="${suggestion.name}" class="p-2 cursor-pointer ${i % 2 ? "bg-slate-200" : ""}">${suggestion.name}, ${suggestion.place_formatted}</li>`).join("") 
     : ""
    suggestionEl.innerHTML = lineItems
    suggestionEl.classList.remove('opacity-0', )
    suggestionEl.classList.remove('h-0')
    suggestionEl.querySelectorAll('li').forEach(item => item.addEventListener('click', e => {
        const value = e.target.getAttribute('data-place-name')
        autofillEl.value = value
        locationHiddenEl.value = value
        suggestionEl.classList.add('opacity-0', )
        suggestionEl.classList.add('h-0')
        }))
}

const debouncedFetch = debounce(fetchSuggestions, 500)
autofillEl.addEventListener('input', debouncedFetch)