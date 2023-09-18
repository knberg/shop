function removeItem(id) {
	const url = `/cart/remove?id=${id}`
	fetch(url, {
	  method: 'POST',
	  headers: {
		'Content-Type': 'application/json',
	  },
	})

	const item = document.querySelector(`.cart-item[data-product-id="${id}"]`);
	item.remove();
	//countFinalPrice();
}

function countFinalPrice() {
	const finalPriceBlock = document.getElementById("final-price-value");
	const cartItems = document.querySelectorAll(".cart-item");

	let finalPrice = 0;

	if (cartItems.length > 0) {
		for (let item of cartItems) {
			const price = parseInt(item.querySelector(".price-value").textContent);
			const quantity = parseInt(item.querySelector(".property-value.quantity").textContent);
			console.log(price, quantity);
			finalPrice += price * quantity;
		}
	}
	finalPriceBlock.innerHTML = finalPrice;
}

countFinalPrice();