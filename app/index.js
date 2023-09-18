const express = require("express");
const session = require('express-session');
const mysql = require("mysql2");
const app = express();

app.set("view engine", "hbs");

app.use(express.static(__dirname + '/public'));

app.use(express.json());

app.use(express.urlencoded({ extended: true }));

app.use(session({
  secret: 'mysecretkey', 
  resave: false,
  saveUninitialized: true
}));

let connection = mysql.createConnection({
    host: "localhost",
    port: 3306,
    user: "root",
    password: "super",
    database: "shopdb"
});

const userCarts = {};

app.use((req, res, next) => {
    const sessionId = req.session.id;
    if (!userCarts[sessionId]) {
        userCarts[sessionId] = [];
        req.session.cart = [];
    }
    next();
});

app.get("/", (req, res) => {
    res.redirect("/c");
});

const manHeaders = new Map();
manHeaders.set("jeans", "Мужские джинсы");
manHeaders.set("t-shirt", "Мужские футболки");
manHeaders.set("pants", "Мужские боюки");
manHeaders.set("hoodie", "Мужские худи");
manHeaders.set("jacket", "Мужские куртки");
manHeaders.set("shorts", "Мужские шорты");
manHeaders.set("shirt", "Мужские рубашки");

const womanHeaders = new Map();
womanHeaders.set("dress", "Женские платья");
womanHeaders.set("sweatshirt", "Женские свитшоты");
womanHeaders.set("jeans", "Женские джинсы");
womanHeaders.set("t-shirt", "Женские футболки");
womanHeaders.set("jacket", "Женские куртки");
womanHeaders.set("blouse", "Женские блузки");
womanHeaders.set("skirt", "Женские юбки");


function buildHeader(gender, category) {
    if (!gender && !category) return "Главная";
    
    else if (gender && !category) return (gender == 'men') ? "Мужская одежда" : "Женская одежда";
    
    else return (gender == 'men') ? manHeaders.get(category) : womanHeaders.get(category);
}

function buildQuery(gender, category) {
    let basic = "SELECT product.id, name, price, modelId, color, quantity, location FROM product INNER JOIN model ON model.id = product.modelId";

    if (!gender && !category)
        return basic;

    else if (gender && !category)
        return basic + ` WHERE gender = '${gender}'`
    
    else if (womanHeaders.has(category) || manHeaders.has(category))
        return basic + ` WHERE gender = '${gender}' AND category = '${category}'`;
    
    return false;
}

app.get("/c/:gender?/:category?", (req, res) => {
    
    const gender = req.params.gender || false;
    const category = req.params.category || false;
    
    const query = buildQuery(gender, category);

    if (query) {
        connection.query(query, (err, results) => {
            if (err) console.error('Ошибка запроса товаров:', err);
            else {
                let models = {};
                for (const prod of results) { 
                    let model = models[prod.modelId];
                    if (!model) {
                        model = {
                            name:     prod.name,
                            price:    prod.price,
                            products: []
                        }
                        models[prod.modelId] = model;
                    }
                    model.products.push(prod);
                }
                res.render("catalog.hbs", { 
                    models: Object.values(models), 
                    header: buildHeader(gender, category) 
                });
              }
          });
    } else {
        res.status(404).sendFile('404.html', { root: __dirname + '/views/' });
    }
});


app.get('/cart', (req, res) => {
    const sessionId = req.session.id;
    const cart = userCarts[sessionId];

    if (cart.length > 0) {
        let list1 = [];
        let list2 = [];
        for (let item of cart) {
            list1.push(item.id);
            list2.push(item.quantity);
        }
        const query = "SELECT product.id, name, price, color, location FROM product INNER JOIN model ON model.id = product.modelId WHERE product.id IN (?);";
        connection.query(query, [list1], (err, cartItems) => {
            if (err) console.error('Ошибка запроса корзины:', err);
            else {
                for (let i = 0; i < cartItems.length; i++) {
                    cartItems[i].quantity = list2[i]
                }
                res.render("cart.hbs", { cartItems, empty: false });
            }
        });
    } else {
        res.render("cart.hbs", { empty: true });
    }
});


app.get('/api/cart-size', (req, res) => {
    const sessionId = req.session.id;
    const cartSize = userCarts[sessionId] ? userCarts[sessionId].length : 0
    res.send({size: cartSize});
});


app.get("/product/:productId", (req, res) => {
    if (!req.body) return res.sendStatus(400);
    const query = `SELECT * FROM product WHERE id = ${req.params.productId};`;
    connection.query(query, (error, results) => {
        res.send(results[0]);
    });
});


app.post('/cart/add', (req, res) => {
    const sessionId = req.session.id;
    const userCart = userCarts[sessionId];
    const newItem = req.body;

    if (newItem) {
        let exist = false;
        for (let item of userCart) {
            if (item.id == newItem.id) {
                item.quantity += newItem.quantity;
                exist = true;
                break;
            }
        }
        if (!exist) userCart.push(newItem);
        req.session.cart.push(newItem);

        res.status(200).json({ message: 'Товар добавлен в корзину: ' });
    } else {
        res.status(400).json({ message: 'Ошибка при добавлении товара' });
    }
});


app.post('/cart/remove', (req, res) => {
    const sessionId = req.session.id;
    const id = req.query.id;
    const userCart = userCarts[sessionId];

    let exist = false;
    for (let i = 0; i < userCart.length; i++) {
        if (userCart[i].id = id) {  // TODO =
            userCart.splice(i, 1);
            exist = true;
            break;
        }
    }
    if (exist) {
        res.status(200).json({ message: 'Товар удалён из корзины' });
    } else {
        res.status(400).json({ message: 'Ошибка при удалении товара' });
    }
});

app.post("/cart/show-orders" , (req, res) => {
    const query = 
    `SELECT order_id, DATE_FORMAT(date, '%d-%m-%Y %H:%m') AS date, model.name, color, order_product.quantity, total_price, location FROM user_order 
    INNER JOIN order_product ON order_product.order_id = user_order.id
    INNER JOIN product ON product.id = order_product.product_id 
    INNER JOIN model ON product.modelId = model.id
    WHERE email = '${req.body.email}';`;

    connection.query(query, (error, results) => {
        const orders = {};

        for (const item of results) {           // Проходим по данным и группируем их по идентификатору заказа
            let order = orders[item.order_id]
            if (!order) {
                order = {
                    id:     item.order_id,
                    date:   item.date,
                    total:  0,
                    products: [],
                };
                orders[item.order_id] = order;
            }
            order.total += parseInt(item.total_price);
            order.products.push({
                name:     item.name,
                color:    item.color,
                quantity: item.quantity,
                total:    item.total_price,
                location: item.location,
            });
        }
        res.render("orders.hbs", { 
            orders:  Object.values(orders),
            empty: orders.length == 0 
        });
    });
});


app.post("/cart/order", (req, res) => {
    const sessionId = req.session.id;
    const userName = req.body.name;
    const userEmail = req.body.email;

    if (!req.body) return res.sendStatus(400);

    const cart = userCarts[sessionId];

    if (cart) {
        const query1 = `INSERT INTO user_order (name, email) VALUES ('${userName}', '${userEmail}')`;
        connection.query(query1, (error, results) => {
            if (error) {
                console.error('Ошибка при внесении данных заказа в базу данных:', error);
            } else {
                const orderId = results.insertId;

                let values = [];

                for (let item of cart) {
                    values.push([orderId, item.id, item.quantity]);
                }

                const query2 = 'INSERT INTO order_product (order_id, product_id, quantity) VALUES ?';
                connection.query(query2, [values], (error, results) => {
                    if (error) console.error('Ошибка при внесении данных в базу данных:', error);
                });
                userCarts[sessionId] = []
                res.redirect("/cart");
            }
        });
    } else {
      res.status(400).json({ message: 'Ошибка при создании заказа, корзина пуста' });
    }
});

app.use((req, res, next) => {
    res.status(404).sendFile('404.html', { root: __dirname + '/views/' });
});

app.listen(3000, () => {console.log("Прослушивание порта 3000")});