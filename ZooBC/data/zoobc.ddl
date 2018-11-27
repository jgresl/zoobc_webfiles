DROP TABLE IF EXISTS ShippingOption;
DROP TABLE IF EXISTS TaxOption;
DROP TABLE IF EXISTS Stores;
DROP TABLE IF EXISTS OrderContains;
DROP TABLE IF EXISTS UserAccount;
DROP TABLE IF EXISTS FillsCart;
DROP TABLE IF EXISTS SavesCard;
DROP TABLE IF EXISTS OrderShipment;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Animal;
DROP TABLE IF EXISTS Warehouse;
DROP TABLE IF EXISTS CreditCard;

CREATE TABLE Animal (
	animal_ID INTEGER IDENTITY,
	animalName VARCHAR(20),
	animalClass VARCHAR(20),
	animalType VARCHAR(20),
	animalSize VARCHAR(10),
	animalDiet VARCHAR(50),
	animalOrigin VARCHAR(50),
	animalPrice DECIMAL(10,2),
	description VARCHAR(1000),
	anaimalImage VARBINARY(5096),
	PRIMARY KEY (animal_ID)
);

CREATE TABLE UserAccount (
	user_ID INTEGER IDENTITY,
	userEmail VARCHAR(30),
	userPassword VARCHAR(20),
	isAdmin BIT, 
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	phoneNumber VARCHAR(20),
	address VARCHAR(80),
	country VARCHAR(20),
	stateProvince CHAR(2),
	zipPostal VARCHAR(10),
	city VARCHAR(20),
	streetName VARCHAR(20),
	streetNumber VARCHAR(10),
	aptNumber VARCHAR(10),
	PRIMARY KEY (user_ID),
	UNIQUE (userEmail)
);

CREATE TABLE Warehouse (
	warehouse_ID INTEGER,
	continent VARCHAR(20),
	country VARCHAR(20),
	PRIMARY KEY (warehouse_ID)
);

CREATE TABLE CreditCard (
	card_ID INTEGER IDENTITY,
	cardType VARCHAR(10),
	cardName VARCHAR(10),
	cardNumber CHAR(16),
	cardExpiration CHAR(4),
	billingAddress VARCHAR(80),
	country VARCHAR(20),
	stateProvince CHAR(2),
	zipPostal VARCHAR(10),
	city VARCHAR(20),
	streetName VARCHAR(20),
	streetNumber VARCHAR(10),
	aptNumber VARCHAR(10),
	user_ID INTEGER,
	PRIMARY KEY (card_ID)
);

CREATE TABLE ShippingOption (
	shipping_ID INTEGER,
	shipMethod VARCHAR(10),
	animalSize VARCHAR(10),
	shipPrice DECIMAL(10,2),
	PRIMARY KEY (shipping_ID)
);

CREATE TABLE TaxOption (
	taxCountry VARCHAR(20),
	taxState CHAR(2),
	taxRate DECIMAL(2,2),
	PRIMARY KEY (taxCountry, taxState)
);	

CREATE TABLE Stores (
	warehouse_ID INTEGER,
	animal_ID INTEGER,
	inventory INTEGER,
	PRIMARY KEY (warehouse_ID, animal_ID)
);

CREATE TABLE FillsCart (
	user_ID INTEGER,
	animal_ID INTEGER,
	cartQuantity INTEGER,
	PRIMARY KEY (user_ID, animal_ID),
	FOREIGN KEY (user_ID) 
		REFERENCES UserAccount(user_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (animal_ID) 
		REFERENCES Animal(animal_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE
);	

CREATE TABLE OrderContains (
	order_ID INTEGER,
	animal_ID INTEGER,
	orderQuantity INTEGER,
	PRIMARY KEY (order_ID, animal_ID)
);

CREATE TABLE SavesCard (
	user_ID INTEGER,
	card_ID INTEGER,
	PRIMARY KEY (user_ID, card_ID),
	FOREIGN KEY (user_ID) 
		REFERENCES UserAccount(user_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (card_ID) 
		REFERENCES CreditCard(card_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE OrderShipment (
	order_ID INTEGER IDENTITY,
	orderDate TIMESTAMP,
	orderStatus VARCHAR(10),
	subTotal DECIMAL(10,2),
	shippingCost DECIMAL(10,2),
	taxCost DECIMAL(10,2),
	grandTotal DECIMAL(10,2),
	cardType VARCHAR(10),
	cardNumber CHAR(16),
	cardExpiration CHAR(4),
	cardCCV CHAR(3),
	billingAddress VARCHAR(80),
	b_country VARCHAR(20),
	b_stateProvince CHAR(2),
	b_zipPostal VARCHAR(10),
	b_city VARCHAR(20),
	b_streetName VARCHAR(20),
	b_streetNumber VARCHAR(10),
	b_aptNumber VARCHAR(10),
	shippingAddress VARCHAR(80),
	s_country VARCHAR(20),
	s_stateProvince CHAR(2),
	s_zipPostal VARCHAR(10),
	s_city VARCHAR(20),
	s_streetName VARCHAR(20),
	s_streetNumber VARCHAR(10),
	s_aptNumber VARCHAR(10),
	warehouse_ID INTEGER,
	shipping_ID INTEGER,
	user_ID INTEGER,
	PRIMARY KEY (order_ID),
	FOREIGN KEY (user_ID) 
		REFERENCES UserAccount(user_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (warehouse_ID) 
		REFERENCES Warehouse(warehouse_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (shipping_ID) 
		REFERENCES ShippingOption(shipping_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (b_country, b_stateProvince) 
		REFERENCES TaxOption(taxCountry, taxState)
		ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE Reviews (
	user_ID INTEGER,
	animal_ID INTEGER,
	dateReviewed TIMESTAMP,
	overallRating INTEGER,
	review VARCHAR(255),
	CHECK (overallRating >= 1 AND overallRating <= 5),
	PRIMARY KEY (user_ID, animal_ID),
	FOREIGN KEY (user_ID) 
		REFERENCES UserAccount(user_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (animal_ID) 
		REFERENCES Animal(animal_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE		
);

INSERT Animal (animalName, animalClass, animalType, animalSize, animalDiet, animalOrigin, animalPrice, description) VALUES('Flying Frog', 'Amphibians', 'Frogs', 'Tiny', 'Insects', 'Southeast Asia', 152.58, 'Despite their name, Flying Frogs cannot fly, but they can glide from tree to tree. They use their large, webbed hands and feet for control as they glide through the air. They also act as parachutes. Flying Frogs lay their eggs high up in the trees of the rain forests where they live. The frogs make foam nests to they their eggs in. They make this foam by mixing mucus with rainwater.');
INSERT Animal (animalName, animalClass, animalType, animalSize, animalDiet, animalOrigin, animalPrice, description) VALUES('Goliath Frog','Amphibians', 'Frogs', 'Small', 'Worms, flying insects, small frogs, turtles', 'Cameroon and neighboring countries', 224.25, 'The Goliath Frog is the largest frog in the world. The heaviest one ever recorded was more than 7.75 pounds (3.5kg), and the legspan was 3 feet (1m). The Goliath frog can be found in the rivers of western tropical Africa. These frogs are now in danger of extinction because of the destruction of their habitat by man-made dams. They are also threatened because they are hunted and sold as pets. They often will not breed in captivity, and this also contributes to this species’ decline.');
INSERT Animal (animalName, animalClass, animalType, animalSize, animalDiet, animalOrigin, animalPrice, description) VALUES('Giant Panda Bear','Mammals', 'Bears', 'Large', 'Insects, small rodents, bamboo, and fruits', 'Mountains in central and western China', 1283.45, 'The giant panda bear can be found in the mountains of central and western China.  You can usually find them hanging out in a tree eating their favorite plant, bamboo.  Giant pandas are considered omnivores, because they eat plants and animals.  Their diet consists of bamboo, fruits, insects, and small rodents.  The giant panda is at risk of going extinct because they continue to loss their natural habitat everyday, as bamboo forests continue to be cut down in China.  A fun fact about the panda, is that it is one of the only bears that do not hibernate.');

