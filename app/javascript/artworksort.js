
import Sortable from 'sortablejs'

const el = document.getElementById('artworks');

const sortable = Sortable.create(el, {
    handle: '.sort-handle',
    animation: 100,
    onEnd: async e => {
        const artworkId = e.item.getAttribute('data-artwork-id')
        const url = `/artworks/${artworkId}/move_artwork?from_index=${e.oldIndex}&to_index=${e.newIndex}`
        const response = await fetch(url, { 
            method: 'PATCH',
        })
        if(response.status != 200) {
            // just in case there is a server error
            alert('Changing artwork order failed. Please refresh the page and try again.')
        }
    },
});
    