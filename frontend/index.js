import { backend } from 'declarations/backend';

document.addEventListener('DOMContentLoaded', async () => {
    const shoppingList = document.getElementById('shopping-list');
    const addItemForm = document.getElementById('add-item-form');
    const newItemInput = document.getElementById('new-item');

    // Function to render the shopping list
    async function renderShoppingList() {
        const items = await backend.getItems();
        shoppingList.innerHTML = '';
        items.forEach(item => {
            const li = document.createElement('li');
            li.innerHTML = `
                <span class="${item.completed ? 'completed' : ''}">${item.description}</span>
                <div class="item-actions">
                    <i class="fas fa-check-circle" data-id="${item.id}"></i>
                    <i class="fas fa-trash-alt" data-id="${item.id}"></i>
                </div>
            `;
            li.querySelector('.fa-check-circle').addEventListener('click', () => toggleItem(item.id));
            li.querySelector('.fa-trash-alt').addEventListener('click', () => deleteItem(item.id));
            shoppingList.appendChild(li);
        });
    }

    // Function to add a new item
    async function addItem(description) {
        await backend.addItem(description);
        newItemInput.value = '';
        await renderShoppingList();
    }

    // Function to delete an item
    async function deleteItem(id) {
        await backend.deleteItem(id);
        await renderShoppingList();
    }

    // Function to toggle item completion
    async function toggleItem(id) {
        await backend.toggleCompleted(id);
        await renderShoppingList();
    }

    // Event listener for form submission
    addItemForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const description = newItemInput.value.trim();
        if (description) {
            await addItem(description);
        }
    });

    // Initial render
    await renderShoppingList();
});