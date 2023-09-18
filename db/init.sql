CREATE TABLE IF NOT EXISTS model (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    gender ENUM('men', 'women') NOT NULL,
    category VARCHAR(30) NOT NULL,
    price INT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    modelId INT NOT NULL,
    color ENUM('white', 'yellow', 'red', 'blue', 'green', 'orange', 'gray', 'pink', 'purple', 'black', 'deepskyblue') NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    location TEXT NOT NULL,
    FOREIGN KEY (modelId) REFERENCES model (id)
);

CREATE TABLE IF NOT EXISTS user_order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_product (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_price INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES user_order (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

DELIMITER //
CREATE TRIGGER calculate_total_price
BEFORE INSERT ON order_product
FOR EACH ROW
BEGIN
    DECLARE product_price INT;
    DECLARE model_id INT;
    -- Получаем цену товара из таблицы product
    SELECT modelId INTO model_id FROM product WHERE id = NEW.product_id;
    SELECT price INTO product_price FROM model WHERE id = model_id;
    -- Вычисляем общую цену на основе цены товара и количества заказанного покупателем
    SET NEW.total_price = product_price * NEW.quantity;
END //
DELIMITER ;

INSERT INTO model (name, price, gender, category) VALUES
    ('Мужская футболка из хлопка', 550, 'men', 't-shirt'),
    ('Мужская классическая однотонная футболка', 350, 'men', 't-shirt'),
    ('Футболка мужская с круглым вырезом', 450, 'men', 't-shirt'),
    ('Футболка мужская с круглым вырезом и короткими рукавами', 550, 'men', 't-shirt'),
    ('Мужская хлопковая футболка', 500, 'men', 't-shirt'),

    ('Стрейчевые обтягивающие джинсы', 729, 'men', 'jeans'),
    ('Мужские прямые джинсы классического стиля', 5761, 'men', 'jeans'),
    ('Мужские прямые укороченные джинсы', 4173, 'men', 'jeans'),
    ('Джинсы мужские расклешенные свободного покроя', 4015, 'men', 'jeans'),

    ('Мужские брюки SIMWOOD', 4168, 'men', 'pants'),
    ('Брюки-карго для мужчин', 477, 'men', 'pants'),
    ('Брюки мужские ультратонкие на молнии', 6796, 'men', 'pants'),
    ('Эластичные водонепроницаемые штаны', 557, 'men', 'pants'),

    ('Рубашка мужская в клетку', 6347, 'men', 'shirt'),
    ('Мужская рубашка с длинными рукавами', 3277, 'men', 'shirt'),
    ('Рубашка мужская однотонная льняная', 5548, 'men', 'shirt'),
    ('мужская рубашка карго', 3339, 'men', 'shirt'),

    ('Мужские однотонные спортивные шорты', 1248, 'men', 'Шорты'),
    ('Мужские шорты с эластичным поясом', 2578, 'men', 'Шорты'),
    ('Мужские шорты из 100% хлопка с вышивкой', 3024, 'men', 'Шорты'),

    ('Однотонная мужская толстовка с капюшоном', 473, 'men', 'hoodie'),
    ('Толстовка Мужская Флисовая', 3349, 'men', 'hoodie'),
    ('Мужская толстовка с капюшоном', 3572, 'men', 'hoodie'),

    ('Мужская флисовая куртка', 1069, 'men', 'jacket'),
    ('Молодежное пальто на молнии с воротником-стойкой', 4899, 'men', 'jacket'),
    ('Мужская осенняя куртка', 2838, 'men', 'jacket'),

    ('Платье с открытыми плечами и V-образным вырезом', 3621, 'women', 'dress'),
    ('Платье повседневное для женщин', 5665, 'women', 'dress'),
    ('Женское летнее хлопковое платье-свитшот с коротким рукавом', 4171, 'women', 'dress'),

    ('Женские джинсы с высокой талией', 1968, 'women', 'jeans'),
    ('Джинсы  женские свободные повседневные', 6772, 'women', 'jeans'),
    ('Женские джинсы с завышенной талией', 2165, 'women', 'jeans'),
    ('эластичные джинсовые брюки', 3089, 'women', 'jeans'),

    ('Женские классические брюки с поясом и высокой талией', 6700, 'women', 'pants'),
    ('женские кашемировые брюки', 6868, 'women', 'pants'),
    ('Классические брюки женские', 4120, 'women', 'pants'),

    ('Женская офисная блузка с длинным рукавом', 1931, 'women', 'blouse'),
    ('Женская клетчатая рубашка', 2932, 'women', 'blouse'),
    ('Элегантная хлопковая офисная рубашка с длинным рукавом', 3003, 'women', 'blouse'),
    
    ('Женское худи с капюшоном', 3528, 'women', 'sweatshirt'),
    ('Свитшот женский', 2587, 'women', 'sweatshirt'),
    ('Кэжуал толстовка', 1174, 'women', 'sweatshirt'),
    ('Толстовка женская с флисовой подкладкой', 1528, 'women', 'sweatshirt'),

    ('Куртка женская зимняя из искусственной кожи с поясом', 961, 'women', 'jacket'),
    ('Женское длинное пальто в  клетку', 3146, 'women', 'jacket'),
    ('Куртка женская из искусственной кожи на молнии', 2087, 'women', 'jacket'),
    ('Женская короткая стеганная куртка', 5886, 'women', 'jacket');

INSERT INTO product (modelId, color, quantity, location) VALUES
    ('1', 'black', 28, '1_black.jpg'),
    ('1', 'green', 1, '1_green.jpg'),
    ('1', 'red', 19, '1_red.jpg'),
    ('10', 'black', 98, '10_black.jpg'),
    ('10', 'green', 71, '10_green.jpg'),
    ('10', 'orange', 96, '10_orange.jpg'),
    ('11', 'black', 94, '11_black.jpg'),
    ('11', 'gray', 78, '11_gray.jpg'),
    ('11', 'green', 88, '11_green.jpg'),
    ('12', 'black', 100, '12_black.jpg'),
    ('12', 'gray', 38, '12_gray.jpg'),
    ('12', 'green', 5, '12_green.jpg'),
    ('12', 'white', 91, '12_white.jpg'),
    ('13', 'black', 44, '13_black.jpg'),
    ('13', 'gray', 94, '13_gray.jpg'),
    ('13', 'green', 39, '13_green.jpg'),
    ('14', 'blue', 88, '14_blue.jpg'),
    ('14', 'deepskyblue', 70, '14_deepskyblue.jpg'),
    ('14', 'green', 28, '14_green.jpg'),
    ('14', 'red', 84, '14_red.jpg'),
    ('15', 'red', 99, '15_red.jpg'),
    ('15', 'white', 65, '15_white.jpg'),
    ('15', 'yellow', 98, '15_yellow.jpg'),
    ('16', 'black', 94, '16_black.jpg'),
    ('16', 'deepskyblue', 76, '16_deepskyblue.jpg'),
    ('16', 'white', 25, '16_white.jpg'),
    ('17', 'black', 87, '17_black.jpg'),
    ('17', 'gray', 77, '17_gray.jpg'),
    ('17', 'white', 32, '17_white.jpg'),
    ('18', 'gray', 35, '18_gray.jpg'),
    ('18', 'green', 100, '18_green.jpg'),
    ('18', 'white', 6, '18_white.jpg'),
    ('19', 'blue', 20, '19_blue.jpg'),
    ('19', 'deepskyblue', 97, '19_deepskyblue.jpg'),
    ('19', 'orange', 57, '19_orange.jpg'),
    ('20', 'green', 4, '20_green.jpg'),
    ('20', 'red', 63, '20_red.jpg'),
    ('21', 'pink', 93, '21_pink.jpg'),
    ('21', 'purple', 67, '21_purple.jpg'),
    ('21', 'yellow', 54, '21_yellow.jpg'),
    ('22', 'gray', 86, '22_gray.jpg'),
    ('22', 'white', 75, '22_white.jpg'),
    ('23', 'blue', 31, '23_blue.jpg'),
    ('23', 'green', 20, '23_green.jpg'),
    ('23', 'red', 17, '23_red.jpg'),
    ('24', 'black', 85, '24_black.jpg'),
    ('24', 'blue', 66, '24_blue.jpg'),
    ('24', 'green', 26, '24_green.jpg'),
    ('24', 'orange', 10, '24_orange.jpg'),
    ('25', 'black', 35, '25_black.jpg'),
    ('25', 'gray', 62, '25_gray.jpg'),
    ('25', 'orange', 24, '25_orange.jpg'),
    ('25', 'red', 98, '25_red.jpg'),
    ('26', 'black', 29, '26_black.jpg'),
    ('26', 'blue', 6, '26_blue.jpg'),
    ('26', 'red', 24, '26_red.jpg'),
    ('27', 'black', 89, '27_black.jpg'),
    ('27', 'red', 39, '27_red.jpg'),
    ('28', 'black', 69, '28_black.jpg'),
    ('28', 'gray', 29, '28_gray.jpg'),
    ('28', 'pink', 89, '28_pink.jpg'),
    ('29', 'blue', 30, '29_blue.jpg'),
    ('29', 'green', 82, '29_green.jpg'),
    ('29', 'pink', 100, '29_pink.jpg'),
    ('2', 'black', 86, '2_black.jpg'),
    ('2', 'red', 21, '2_red.jpg'),
    ('2', 'white', 68, '2_white.jpg'),
    ('2', 'yellow', 5, '2_yellow.jpg'),
    ('30', 'black', 66, '30_black.jpg'),
    ('30', 'blue', 5, '30_blue.jpg'),
    ('30', 'deepskyblue', 13, '30_deepskyblue.jpg'),
    ('31', 'blue', 25, '31_blue.jpg'),
    ('32', 'blue', 99, '32_blue.jpg'),
    ('32', 'deepskyblue', 86, '32_deepskyblue.jpg'),
    ('32', 'gray', 92, '32_gray.jpg'),
    ('33', 'deepskyblue', 30, '33_deepskyblue.jpg'),
    ('33', 'red', 58, '33_red.jpg'),
    ('34', 'deepskyblue', 43, '34_deepskyblue.jpg'),
    ('34', 'orange', 6, '34_orange.jpg'),
    ('34', 'pink', 24, '34_pink.jpg'),
    ('35', 'black', 89, '35_black.jpg'),
    ('35', 'white', 64, '35_white.jpg'),
    ('36', 'black', 72, '36_black.jpg'),
    ('36', 'orange', 16, '36_orange.jpg'),
    ('36', 'white', 38, '36_white.jpg'),
    ('37', 'blue', 52, '37_blue.jpg'),
    ('37', 'deepskyblue', 86, '37_deepskyblue.jpg'),
    ('37', 'pink', 18, '37_pink.jpg'),
    ('37', 'yellow', 73, '37_yellow.jpg'),
    ('38', 'orange', 41, '38_orange.jpg'),
    ('38', 'pink', 69, '38_pink.jpg'),
    ('38', 'purple', 17, '38_purple.jpg'),
    ('38', 'yellow', 99, '38_yellow.jpg'),
    ('39', 'blue', 52, '39_blue.jpg'),
    ('39', 'red', 79, '39_red.jpg'),
    ('39', 'white', 52, '39_white.jpg'),
    ('3', 'black', 74, '3_black.jpg'),
    ('3', 'blue', 46, '3_blue.jpg'),
    ('3', 'gray', 77, '3_gray.jpg'),
    ('3', 'white', 40, '3_white.jpg'),
    ('40', 'black', 49, '40_black.jpg'),
    ('40', 'blue', 97, '40_blue.jpg'),
    ('40', 'gray', 68, '40_gray.jpg'),
    ('40', 'purple', 74, '40_purple.jpg'),
    ('41', 'gray', 6, '41_gray.jpg'),
    ('41', 'orange', 31, '41_orange.jpg'),
    ('41', 'red', 22, '41_red.jpg'),
    ('41', 'white', 5, '41_white.jpg'),
    ('42', 'orange', 15, '42_orange.jpg'),
    ('42', 'pink', 18, '42_pink.jpg'),
    ('42', 'purple', 10, '42_purple.jpg'),
    ('43', 'black', 47, '43_black.jpg'),
    ('43', 'green', 95, '43_green.jpg'),
    ('43', 'red', 63, '43_red.jpg'),
    ('43', 'yellow', 41, '43_yellow.jpg'),
    ('44', 'black', 88, '44_black.jpg'),
    ('44', 'white', 97, '44_white.jpg'),
    ('45', 'blue', 33, '45_blue.jpg'),
    ('45', 'green', 76, '45_green.jpg'),
    ('45', 'red', 10, '45_red.jpg'),
    ('46', 'black', 79, '46_black.jpg'),
    ('46', 'pink', 81, '46_pink.jpg'),
    ('47', 'black', 58, '47_black.jpg'),
    ('47', 'deepskyblue', 82, '47_deepskyblue.jpg'),
    ('47', 'red', 27, '47_red.jpg'),
    ('47', 'white', 95, '47_white.jpg'),
    ('4', 'black', 98, '4_black.jpg'),
    ('4', 'blue', 78, '4_blue.jpg'),
    ('4', 'white', 95, '4_white.jpg'),
    ('4', 'yellow', 63, '4_yellow.jpg'),
    ('5', 'black', 33, '5_black.jpg'),
    ('5', 'green', 88, '5_green.jpg'),
    ('5', 'pink', 19, '5_pink.jpg'),
    ('5', 'white', 5, '5_white.jpg'),
    ('6', 'black', 93, '6_black.jpg'),
    ('6', 'blue', 57, '6_blue.jpg'),
    ('6', 'gray', 78, '6_gray.jpg'),
    ('6', 'white', 61, '6_white.jpg'),
    ('7', 'black', 99, '7_black.jpg'),
    ('7', 'blue', 41, '7_blue.jpg'),
    ('7', 'gray', 99, '7_gray.jpg'),
    ('8', 'black', 98, '8_black.jpg'),
    ('8', 'blue', 90, '8_blue.jpg'),
    ('8', 'deepskyblue', 36, '8_deepskyblue.jpg'),
    ('9', 'black', 92, '9_black.jpg'),
    ('9', 'blue', 86, '9_blue.jpg'),
    ('9', 'deepskyblue', 82, '9_deepskyblue.jpg'),
    ('9', 'gray', 28, '9_gray.jpg');