--controllo che il prodotto 'GTXPro' di zero righe dopo la modifica
select sp.product, count(*)
from sales_pipeline sp left join products p on sp.product=p.product
where p.product  is null
group by sp.product;