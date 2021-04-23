SELECT category_set_name, category_concat_segments, COUNT (*)
FROM mtl_category_set_valid_cats_v
WHERE (category_set_id = 1)
GROUP BY category_set_name, category_concat_segments
HAVING COUNT (*) > 1
ORDER BY category_concat_segments