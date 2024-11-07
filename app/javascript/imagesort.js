import Sortable from 'sortablejs'
console.log('sortable', Sortable)

var el = document.getElementById('image-list');
const artworkId = el.getAttribute('data-artwork-id')
console.log(el)
var sortable = Sortable.create(el, {
    handle: '.sort-handle',
    animation: 100,
    filter: '.ignore-drag',
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