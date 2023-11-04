-- ********************************************************* I Thiết kế cơ sở dữ liệu **********************************************************
create database ecommerce;
use ecommerce;
-- Tạo bảng danh mục sản phẩm
CREATE TABLE product_category (
    category_id VARCHAR(2) PRIMARY KEY,
    category_name VARCHAR(10) NOT NULL,
    category_status BIT NOT NULL
);
-- Tạo bảng sản phẩm product
CREATE TABLE product (
    product_id VARCHAR(2) PRIMARY KEY,
    product_name VARCHAR(5) NOT NULL UNIQUE,
    product_import INT CHECK (product_import > 0),
    product_export INT CHECK (product_export > 0),
    product_title VARCHAR(10) NOT NULL,
    product_description VARCHAR(255) NOT NULL,
    product_quantity INT NOT NULL,
    product_status ENUM('bán', 'không bán', 'hết hàng'),
);

-- Tạo bảng người dùng end_user
CREATE TABLE end_user (
    end_user_id VARCHAR(2) PRIMARY KEY,
    end_user_login_name VARCHAR(5) NOT NULL,
    end_user_password VARCHAR(5) NOT NULL,
    end_user_name VARCHAR(5) NOT NULL,
    end_user_phone VARCHAR(10) NOT NULL,
    end_user_address VARCHAR(10) NOT NULL
);

-- Tạo bảng hóa đơn invoice
CREATE TABLE invoice (
    invoice_id VARCHAR(2) PRIMARY KEY,
    invoice_date DATE NOT NULL,
    end_user_id VARCHAR(2),
    FOREIGN KEY (end_user_id)
        REFERENCES end_user (end_user_id),
    invoice_status ENUM('đang đặt', 'đã duyệt', 'đang chuyển hàng', 'đã nhận hàng', 'hoàn tất')
);

-- tạo bảng hóa đơn chi tiết invoice_details
CREATE TABLE invoice_details (
    invoice_details_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id VARCHAR(2),
    FOREIGN KEY (invoice_id)
        REFERENCES invoice (invoice_id),
    product_id VARCHAR(2),
    FOREIGN KEY (product_id)
        REFERENCES product (product_id),
    price INT NOT NULL,
    quantity INT NOT NULL,
    total INT NOT NULL
);

-- tạo bảng bình luận comment
CREATE TABLE comment (
    comment_id VARCHAR(2) PRIMARY KEY,
    end_user_id VARCHAR(2),
    FOREIGN KEY (end_user_id)
        REFERENCES end_user (end_user_id),
    product_id VARCHAR(2),
    FOREIGN KEY (product_id)
        REFERENCES product (product_id),
    comment_details VARCHAR(255) NOT NULL,
    comment_date DATE NOT NULL,
    comment_status ENUM('đang bình luận', 'đã được duyệt')
);
rename table comment to user_comment;

-- thêm khóa ngoại category_id cho product 
alter table product
add     category_id VARCHAR(2);
alter table product
add constraint add_product_fk foreign key (category_id) references product_category (category_id);

-- ********************************************* II Thực hiện thao tác dữ liệu  ************************************************************************

-- 1 thêm mỗi bảng 5 dữ liệu 

insert into product_category
value ('c1','banh',true),
	('c2','keo',true),
	('c3','che',true),
    ('c4','chao',false),
    ('c5','nuoc',true);
select * from product_category;
insert into product
value ('p1','banh1',100000,110000,'bánh số 1','bánh đặt cho số 1',1,'bán','c1'),
	('p2','banh2',200000,210000,'bánh số 2','bánh đặt cho số 2',2,'không bán','c1'),
    ('p3','keo3',300000,310000,'bánh số 3','bánh đặt cho số 3',3,'bán','c2'),
    ('p4','chao4',400000,410000,'bánh số 4','bánh đặt cho số 4',4,'hết hàng','c4'),
    ('p5','nuoc5',500000,510000,'bánh số 5','bánh đặt cho số 5',5,'bán','c5');
select * from product;
insert into end_user
value ('u1','user1','12345','anh','0987654321','hà nội1'),
	('u2','user2','12345','anh2','0987654322','hà nội2'),
    ('u3','user3','12345','anh3','0987654323','hà nội3'),
    ('u4','user4','12345','anh4','0987654324','hà nội4'),
    ('u5','user5','12345','anh5','0987654325','hà nội5');

insert into invoice
value ('i1','2023-11-01','u1','đang đặt'),
	('i2','2023-11-02','u2','đang đặt'),
    ('i3','2023-11-03','u3','đã duyệt'),
    ('i4','2023-11-04','u4','đang chuyển hàng'),
    ('i5','2023-11-05','u5','hoàn tất');
    
insert into invoice_details (invoice_id,product_id,price,quantity,total)
value('i1','p1',100000,2,200000),
	('i2','p2',200000,1,200000),
    ('i3','p3',300000,1,200000),
    ('i4','p4',400000,1,300000),
    ('i5','p5',500000,1,400000);    
select * from invoice_details;

insert into user_comment
value('c1','u1','p1','rất ngon','2023-11-1','đang bình luận'),
	('c2','u2','p2','rất tuyệt','2023-11-2','đang bình luận'),
    ('c3','u3','p3','good','2023-11-2','đang bình luận'),
    ('c4','u4','p4','verygood','2023-11-3','đang bình luận'),
    ('c5','u5','p5','hảo hảo','2023-11-5','đã được duyệt');
select * from user_comment;
-- 2 Cập nhật thông tin mỗi bảng 1 dữ liệu

update product_category set category_name = 'che2' where category_id = 'c3';
update product set product_export = 700000 where product_id = 'p2';
update end_user set end_user_password = '11111' where end_user_id = 'u1';
update invoice set invoice_date = '2023-10-30' where invoice_id = 'i5';
update invoice_details set quantity = 500000 where invoice_details_id = '5';
update user_comment set comment_details = 'không ngon' where comment_id = 'c1';

-- 3. Thực hiện Truy vấn
-- a. Lấy ra tất cả các sản phẩm gồm các thông tin:

select pt.product_id, pt.product_name, pt.product_import,pt.product_export, pt.product_title, pt.product_description, pt.product_quantity, pt.product_status, pt.category_id
from product pt;

-- b. Lấy tất cả thông tin sản phẩm có ký tự thứ 2 là ‘a

select pt.product_id, pt.product_name, pt.product_import,pt.product_export, pt.product_title, pt.product_description, pt.product_quantity, pt.product_status, pt.category_id
from product pt
where substring(pt.product_name, 2,1) = 'a';

-- c. Lấy tất cả thông tin sản phẩm có giá nhận 1 trong các giá trị sau: 100.000,350.000, 700.000
select pt.product_id, pt.product_name, pt.product_import,pt.product_export, pt.product_title, pt.product_description, pt.product_quantity, pt.product_status, pt.category_id
from product pt
where pt.product_export in(100000,350000,700000);

-- d. Lấy ra tất cả các sản phẩm có giá nhập trong khoảng từ 100.000 đến 500.000 và sắp xếp theo giá nhập tăng dần
select pt.product_id, pt.product_name, pt.product_import,pt.product_export, pt.product_title, pt.product_description, pt.product_quantity, pt.product_status, pt.category_id
from product pt
where pt.product_import between 100000 and 500000
order by pt.product_export asc;

-- e. Lấy ra tất cả các bình luận của khách hàng

select uc.comment_id, uc.end_user_id,uc.product_id,uc.comment_details,uc.comment_date,uc.comment_status
from user_comment uc
order by uc.comment_date desc;

-- f. In thông tin 3 sản phẩm được bán nhiều nhất...

-- g. In thông tin hóa đơn có tổng tiền lớn nhất
select max_table.total_max, ivd.invoice_details_id, ivd.invoice_id, ivd.product_id,ivd.price,ivd.quantity
from invoice_details ivd
join(
select max(ivd.total) as total_max
from invoice_details ivd
) max_table on ivd.total = max_table.total_max;

-- h. In ra số lượng sản phẩm của từng danh mục
select pc.category_id,pc.category_name, count(pr.product_name)
from product_category pc join product pr on pc.category_id = pr.category_id
group by pc.category_id;

-- i. In thông tin người dùng mua hàng nhiều nhất
