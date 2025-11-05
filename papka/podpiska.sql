CREATE TABLE "Подписчики" (
  "id" int PRIMARY KEY,
  "фамилия" varchar,
  "имя" varchar,
  "отчество" varchar,
  "адрес" varchar
);

CREATE TABLE "Издания" (
  "id" int PRIMARY KEY,
  "индекс" varchar,
  "название" varchar,
  "цена_месяц" decimal
);

CREATE TABLE "Подписки" (
  "id" int PRIMARY KEY,
  "id_подписчика" int,
  "id_издания" int,
  "месяцев" int
);

ALTER TABLE "Подписки" ADD FOREIGN KEY ("id_подписчика") REFERENCES "Подписчики" ("id");

ALTER TABLE "Подписки" ADD FOREIGN KEY ("id_издания") REFERENCES "Издания" ("id");
