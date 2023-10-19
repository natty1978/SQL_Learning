---------------------------
# задание 1 - показывала на уроке 
---------------------------
# задание 2 -Создать таблицу Goods (Name, Price, Discount NULL)  Создать таблицу SeasonPrice (Value)  Вывести все товары и актуальные цены на них. 
# Если прописана скидка в таблице Goods -использовать ее. 
# Если не прописана, использовать значение из таблицы SeasonPrice. Если и там нет значения - скидка 0%.
----------------------------
SELECT
    goods.`name` AS item_name,
    CASE
        WHEN goods.discount IS NOT NULL THEN goods.price - (goods.price * goods.discount / 100)
        WHEN season_price.`value` IS NOT NULL THEN season_price.`value`
        ELSE goods.price
    END AS actual_price
FROM
    learning.goods 
LEFT JOIN
    learning.season_price  ON  goods.good_id = season_price.good_id;

------------------------------------------------------------------------------------------
# задание 3 -Задача на дом: К предыдущему заданию добавить время действия сезонной скидки: с.. по... 
# При учете сезонной скидки надо выбрать наибольшую скидку, действующую в данный момент.
----------------------------

SELECT
    g.`name` AS item_name,
    g.price,
    g.discount,
    sp.`value` AS season_discount,
    CASE
        WHEN sp.`value` IS NOT NULL THEN
            CASE
                WHEN g.discount IS NOT NULL AND sp.validity_from <= NOW() AND (sp.validity_to IS NULL OR sp.validity_to >= NOW()) THEN
                    sp.`value` - (sp.`value` * g.discount / 100)
                ELSE sp.`value`
            END
        WHEN g.discount IS NOT NULL THEN
            CASE
                WHEN sp.validity_from <= NOW() AND (sp.validity_to IS NULL OR sp.validity_to >= NOW()) THEN
                    g.price - (g.price * g.discount / 100)
                ELSE g.price
            END
        ELSE 0
    END AS actual_price,
    (SELECT MAX(discount)
     FROM learning.goods
     WHERE (validity_from <= NOW() AND (validity_to IS NULL OR validity_to >= NOW()))
     ) AS bigger_discount
FROM
    learning.goods g
LEFT JOIN
    learning.season_price sp ON g.good_id = sp.good_id;
