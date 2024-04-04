
const locationItems = document.querySelectorAll('.location-item')
const locationMoreBtn = document.getElementById('location-more')
const locationSerachEl = document.getElementById('location-serach')

const mediumItems = document.querySelectorAll('.medium-item')
const mediumMoreBtn = document.getElementById('medium-more')
const mediumSerachEl = document.getElementById('medium-serach')

function addSearch(inputEl, items) {
    inputEl.addEventListener('input', e => {
        const input = e.target.value
        items.forEach(item => {
            const locText = item.getAttribute('data-text')
            if( locText.toLowerCase().indexOf(input.toLowerCase()) > -1 ) {
                item.classList.remove('hidden')
                item.classList.add('opacity-100')
            }
            else {
                item.classList.add('hidden')
                item.classList.remove('opacity-100')

            }
        })
    })
}

function addExpand(btn, items) {
    btn.addEventListener('click', () => {
        const isOpen = btn.getAttribute('data-open')
        items.forEach((item, i) => {
            if( isOpen == null ) {
                btn.setAttribute('data-open', 'true')
                btn.innerText = 'show less'
                item.classList.remove('hidden')
                item.classList.add('opacity-100') // FIXME: transition not working
                
            }
            else {
                btn.innerText = 'show all'
                btn.removeAttribute('data-open')
                if( i >= 5 ) {
                    item.classList.add('hidden')
                    item.classList.remove('opacity-100') // FIXME: transition not working
    
                }
            }
        })
    })

}

addExpand(locationMoreBtn, locationItems)

addExpand(mediumMoreBtn, mediumItems)

addSearch(locationSerachEl, locationItems)

addSearch(mediumSerachEl, mediumItems)
