#Sanchez CreateStatements.sql

DROP DATABASE IF EXISTS sanchez; CREATE DATABASE sanchez; USE sanchez; CREATE TABLE Accounts ( 
aid VARCHAR(20),
    full_name VARCHAR(20),
    pass VARCHAR(20),
    PRIMARY KEY (aid) ); CREATE TABLE Emails( email VARCHAR(20),
    aid VARCHAR(20),
    PRIMARY KEY (email), FOREIGN KEY (aid) REFERENCES Accounts(aid) ON DELETE CASCADE );
#---------DATE accepts yyyy-mm-dd
CREATE TABLE Users( uid VARCHAR(20),
    gender CHAR(1),
    dob DATE,
    PRIMARY KEY (uid),
    FOREIGN KEY (uid) REFERENCES Accounts(aid) ON DELETE CASCADE );
    
# poc will be a phone number
CREATE TABLE Suppliers( sid VARCHAR(20),
    revenue REAL,
    category VARCHAR(20),
    poc VARCHAR(20),
    PRIMARY KEY (sid),
    FOREIGN KEY (sid) REFERENCES Accounts(aid) ON DELETE CASCADE );
    
CREATE TABLE HasPhoneNumber( aid VARCHAR(20),
    phone_number VARCHAR(20),
    PRIMARY KEY (aid),
    FOREIGN KEY (aid) REFERENCES Accounts(aid) ON DELETE CASCADE );
    
    
CREATE TABLE Addresses (
    address_id INTEGER AUTO_INCREMENT,
    street VARCHAR(100),
    city VARCHAR(20),
    state CHAR(2),
    zip INTEGER(5),
    PRIMARY KEY (address_id) ); CREATE TABLE HasAddress( aid VARCHAR(20), address_id INTEGER, 
PRIMARY KEY (aid, address_id), FOREIGN KEY (aid) REFERENCES Accounts(aid) ON DELETE CASCADE, 
FOREIGN KEY (address_id) REFERENCES Addresses(address_id) ON DELETE CASCADE );
    
# Kept date so it's easier to compare to current date
CREATE TABLE CreditCards (
    uid VARCHAR(20),
    card_number INTEGER(16),
    name_on_card VARCHAR(20),
    expiration DATE,
    three_digit_code INTEGER(3),
    bills_to INTEGER,
    PRIMARY KEY (uid, card_number),
    FOREIGN KEY (uid) REFERENCES Users(uid) ON DELETE CASCADE,
    FOREIGN KEY (bills_to) REFERENCES Addresses(address_id) ON DELETE NO ACTION );
# Category will denote bid vs sale We'll have to go through every so often and delete 
# transactions with all null FKs
CREATE TABLE Transactions (
    tid INTEGER AUTO_INCREMENT,
    category CHAR(1),
    tracking_number VARCHAR(35),
    date_of_sale DATE,
    seller VARCHAR(20),
    buyer VARCHAR(20),
    paid_with INTEGER(16),
    ships_to INTEGER,
    ships_from INTEGER,
    PRIMARY KEY (tid),
    UNIQUE (tracking_number , date_of_sale),
    FOREIGN KEY (seller) REFERENCES Accounts(aid) ON DELETE SET NULL,
    FOREIGN KEY (buyer) REFERENCES Users(uid) ON DELETE SET NULL,
    FOREIGN KEY (buyer, paid_with) REFERENCES CreditCards(uid, card_number) ON DELETE SET NULL,
    FOREIGN KEY (ships_to) REFERENCES Addresses(address_id) ON DELETE SET NULL,
    FOREIGN KEY (ships_from) REFERENCES Addresses(address_id) ON DELETE SET NULL ); CREATE TABLE 
ItemDesc( upc VARCHAR(20),
    description VARCHAR(500),
    PRIMARY KEY (UPC) );
# UPC can start with zero, so use varchar
CREATE TABLE Items( pid INTEGER AUTO_INCREMENT, location VARCHAR(20), bid BOOLEAN, upc 
VARCHAR(20), list_price REAL, auction_price REAL, reserve_price REAL, bid_start TIMESTAMP, 
bid_end TIMESTAMP, included_in INTEGER, PRIMARY KEY (pid),
    FOREIGN KEY (included_in) REFERENCES Transactions(tid) ON DELETE CASCADE,
    FOREIGN KEY (upc) REFERENCES ItemDesc(upc) ON DELETE NO ACTION ); CREATE TABLE HasTag( pid 
INTEGER,
    tag VARCHAR(20),
    PRIMARY KEY (pid, tag),
    FOREIGN KEY (pid) REFERENCES Items(pid) ON DELETE CASCADE ); CREATE TABLE Categories( 
catagory VARCHAR(20),
    description VARCHAR(100),
    PRIMARY KEY (catagory) ); CREATE TABLE HasSub( parent VARCHAR(20),
    child VARCHAR(20),
    PRIMARY KEY (parent, child),
    FOREIGN KEY (parent) REFERENCES Categories(catagory) ON DELETE NO ACTION,
    FOREIGN KEY (child) REFERENCES Categories(catagory) ON DELETE CASCADE ); CREATE TABLE Rating( 
rater VARCHAR(20),
    ratee VARCHAR(20),
    stars INTEGER(1),
    r_date DATE,
    description VARCHAR(500),
    PRIMARY KEY (rater, ratee),
    FOREIGN KEY (rater) REFERENCES Accounts(aid) ON DELETE CASCADE,
    FOREIGN KEY (ratee) REFERENCES Accounts(aid) ON DELETE CASCADE ); CREATE TABLE Message( 
sender VARCHAR(20),
    receiver VARCHAR(20),
    m_date DATE,
    message VARCHAR(500),
    PRIMARY KEY (sender, receiver, m_date),
    FOREIGN KEY (sender) REFERENCES Accounts(aid) ON DELETE CASCADE,
    FOREIGN KEY (receiver) REFERENCES Accounts(aid) ON DELETE CASCADE ); CREATE TABLE HasInCart( 
uid VARCHAR(20),
    pid INTEGER,
    PRIMARY KEY (uid, pid),
    FOREIGN KEY (uid) REFERENCES Users(uid) ON DELETE CASCADE,
    FOREIGN KEY (pid) REFERENCES Items(pid) ON DELETE CASCADE ); CREATE TABLE Wishes( uid 
VARCHAR(20),
    pid INTEGER,
    w_date DATE,
    PRIMARY KEY (uid, pid),
    FOREIGN KEY (uid) REFERENCES Users(uid) ON DELETE CASCADE,
    FOREIGN KEY (pid) REFERENCES Items(pid) ON DELETE CASCADE
    ); CREATE TABLE Bid( uid VARCHAR(20),
    pid INTEGER,
    b_date DATE,
    amount REAL,
    PRIMARY KEY (uid, pid, b_date),
    FOREIGN KEY (uid) REFERENCES Users(uid) ON DELETE CASCADE,
    FOREIGN KEY (pid) REFERENCES Items(pid) ON DELETE CASCADE ); CREATE TABLE IsIn( pid INTEGER,
    catagory VARCHAR(20),
    PRIMARY KEY (pid, catagory),
    FOREIGN KEY (catagory) REFERENCES Categories(catagory) ON DELETE NO ACTION ); CREATE TABLE 
RateItem( rater VARCHAR(20),
    upc VARCHAR(20),
    stars INTEGER(1),
    description VARCHAR(300),
    r_date DATE,
    PRIMARY KEY (rater, upc),
    FOREIGN KEY (rater) REFERENCES Users(uid) ON DELETE CASCADE,
    FOREIGN KEY (upc) REFERENCES ItemDesc(upc) ON DELETE CASCADE ); CREATE TABLE Owns( pid 
INTEGER,
    owner_id VARCHAR(20) NOT NULL,
    PRIMARY KEY (pid),
    FOREIGN KEY (pid) REFERENCES Items(pid) ON DELETE CASCADE,
    FOREIGN KEY (owner_id) REFERENCES Accounts(aid) ON DELETE NO ACTION );