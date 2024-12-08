
import Sortable from 'sortablejs'

const el = document.getElementById('image-list');
const artworkId = el.getAttribute('data-artwork-id')

const sortable = Sortable.create(el, {
    handle: '.sort-handle',
    animation: 100,
   // filter: '.ignore-drag',
    onEnd: async e => {
        const imageId = e.item.getAttribute('data-image-id')
        const url = `/artworks/${artworkId}/images/${imageId}/move_image?from_index=${e.oldIndex}&to_index=${e.newIndex}`
        const response = await fetch(url, { 
            method: 'PATCH',
        })
        if(response.status != 200) {
            // just in case there is a server error
            alert('Changing image order failed. Please refresh the page and try again.')
        }
    },
    onMove: e => {
        // disable dragging image over 'add artwork image' block
        return e.related.className.indexOf('ignore-drag') === -1
    }
});

const editButtons = document.querySelectorAll('.edit-caption-icon')

editButtons.forEach(btn => {
    btn.addEventListener('click', e => {
        const imageId = e.target.getAttribute('data-image-id')
        const formId = `caption-form${imageId}`
        const captionId = `caption${imageId}`
        document.getElementById(formId).style.opacity = 1
        document.getElementById(captionId).style.opacity = 0
        
    })
})
    