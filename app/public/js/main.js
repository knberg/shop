const productsContainer = document.querySelector(".product-container");
const productCards = productsContainer.querySelectorAll('.product-card')
const cartButton = document.querySelector('.cart-button');
const cartIndicator = document.querySelector('.cart-indicator');

productCards.forEach((card) => addCardListeners(card));
setCartSize();

function addCardListeners(card) {
	const colorSelectors = card.querySelectorAll('.color-selector');
	const quantityCounter = card.querySelector('.quantity-counter');
	const image = card.querySelector('.product-image');
	const plusButton = card.querySelector('.plus-button');
	const minusButton = card.querySelector('.minus-button');
	
	image.addEventListener("click", () => {
		openModal(image)
	});
	
	colorSelectors.forEach(selector =>
		selector.addEventListener('click', () => chengeColor(selector))
	);

	plusButton.addEventListener('click', () => {
		updateQuantity(quantityCounter, true);
	});

	minusButton.addEventListener('click', () => {
		updateQuantity(quantityCounter, false);
	});

	quantityCounter.addEventListener('click', () => {
		const productId = card.getAttribute('data-product-id');
		const selectedQuantity = quantityCounter.getAttribute('data-quantity');
		addToCart({ id: productId, quantity: parseInt(selectedQuantity) });
	});
} 

function chengeColor(selector) {
	const selectedID = selector.getAttribute("data-product-id");
	const card = selector.closest(".product-card");
	const image = card.querySelector(".product-image");
	const stock = card.querySelector('.product-stock-value');
	card.setAttribute("data-product-id", selectedID);

	fetch('/product/' + selectedID)
		.then(res => res.json())
		.then(data => {
			image.src = '/images/' + data.location;
			stock.textContent = data.quantity;
		});

	const colorSelectors = card.querySelectorAll('.color-selector');
	colorSelectors.forEach(selector => selector.classList.remove('selected'));
	selector.classList.add('selected');
}

function updateQuantity(quantityCounter, increment) {
	const currentValue = parseInt(quantityCounter.getAttribute("data-quantity"));
	const newValue = increment ? currentValue + 1 : currentValue - 1;
	quantityCounter.setAttribute("data-quantity", newValue);
	quantityCounter.textContent = (newValue == 1) ? "В корзину" : "Добавить " + newValue + " шт";
}

function setCartSize() {
	fetch('/api/cart-size')
		.then(res => res.json())
		.then(data => cartIndicator.textContent = data.size)
}

function addToCart(product) {
	fetch('/cart/add', {
	  method: 'POST',
	  headers: { 'Content-Type': 'application/json' },
	  body: JSON.stringify(product),
	})
		.then((res) => res.json())
		.then((data) => console.log(data.message))
		.then(setCartSize())
}

// модальное окно с картинкой
const modalWindow = document.getElementById("modal-window");
const modalImage = document.getElementById("modal-image");

function openModal(productImage) {
	modalWindow.style.display = "block";
	modalImage.src = productImage.src;
}

function closeModal() {
	modalWindow.style.display = "none";
}