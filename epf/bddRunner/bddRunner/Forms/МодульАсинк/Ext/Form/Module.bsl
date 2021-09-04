﻿&НаКлиенте
Перем МодальностьЗапрещена Экспорт;

// Используемые плагины
&НаКлиенте
Перем СтроковыеУтилиты;

// -------------------------------------------------------
//
//	МОДАЛЬНЫЕ ВЫЗОВЫ
//

// Правило присвоения имен методам:
//
// 1.	смв_<ИмяМетодаВБезмодальномВарианте>.  Например, "смв_ПоказатьПредупреждение".
// 2.	смв_<ИмяТипаОбъекта>_<ИмяМетодаОбъектаВБезмодальномВарианте>.  Например, "смв_Форма_ПоказатьВыборИзМеню".
//		В этом случае первым параметром метода должен идти сам объект, метод которого вызывается.
//
// Префикс "смв" - аббревиатура "Синхронные/модальные вызовы".
//
// Веб-клиент не поддерживает "Выполнить", поэтому вариант веб-клиента считаем всегда безмодальным и асинхронным.
// По сути все методы по сигнатуре должны совпадать с исходными методами из самых последних версий платформы 8.3,
//		и лишь обеспечивать обратную совместимость с более старыми платформами.
// Т.е. основные модули пишем так, как если бы работали на последней платформе без режима совместимости.
// А модальные/синхронные методы вызываем через данную прослойку.

#Область Обработчики_оповещений

&НаКлиенте
Процедура ПустоеОповещение(РезультатВыполнения, ДополнительныеПараметры = Неопределено) Экспорт

КонецПроцедуры

&НаКлиенте
Процедура ПолучениеКаталогаВременныхФайловДляСохраненияЗавершение(КаталогВременныхФайлов, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(КаталогВременныхФайлов) Тогда

		смв_ПолучитьФайлы(ДополнительныеПараметры.ОповещениеЗавершенияСохранения,
							ДополнительныеПараметры.ДанныеДляСохранения,
							КаталогВременныхФайлов);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Вспомогательные_процедуры_функции

&НаКлиенте
Функция СформироватьСтрокуФильтраДиалогаВыбораФайла(СписокФорматовФайлов) Экспорт

	Результат	= "";
	Разделитель	= "";

	Для Каждого ТипФайла Из СтроковыеУтилиты().РазложитьСтрокуВМассивПодстрок(СписокФорматовФайлов) Цикл

		Результат = Результат + Разделитель + СформироватьСтрокуФильтра(ТипФайла);
		Разделитель = "|";

	КонецЦикла;

	Возврат Результат;

КонецФункции

&НаКлиенте
Функция СформироватьСтрокуФильтра(ФорматФайла)

	Результат = "";

	Если ВРег(ФорматФайла)			= "WORD" Тогда

		Результат = "Документы Word|*.doc?";

	ИначеЕсли ВРег(ФорматФайла)		= "EXCEL" Тогда

		Результат = "Книги Excel|*.xls?";

	ИначеЕсли ВРег(ФорматФайла)		= "PDF" Тогда

		Результат = "Файлы PDF|*.pdf";

	ИначеЕсли ВРег(ФорматФайла)		= "TEXT" Тогда

		Результат = "Текстовые файлы|*.txt";

	ИначеЕсли ВРег(ФорматФайла)		= "XML" Тогда

		Результат = "Файлы XML|*.xml";

	Иначе

		Результат = "Все файлы|*.*";

	КонецЕсли;

	Возврат Результат;
КонецФункции

&НаКлиенте
Функция СформироватьСтрокуФильтраПоРасширению(Знач РасширениеФайла)

	РасширениеФайла = ВРег(РасширениеФайла);

	Результат		= "";
	Если РасширениеФайла = "CF" Тогда

		Результат	= "Файл конфигурации (cf) |*.%1";

	ИначеЕсли РасширениеФайла = "EPF" Тогда

		Результат	= "Внешняя обработка (epf)|*.%1";

	ИначеЕсли РасширениеФайла = "MXL" Тогда

		Результат	= "Табличный документ 1с (mxl)|*.%1";

	Иначе

		Результат	= "%1|*.%1";

	КонецЕсли;

	Возврат СтроковыеУтилиты().ПодставитьПараметрыВСтроку(Результат, РасширениеФайла);

КонецФункции

&НаКлиенте
Функция ТиповаяСтруктураДиалогаВыбораФайла(Заголовок = "", Каталог = "", МножественныйВыбор = Ложь, ПолноеИмяФайла = "", Фильтр = "")

	ТиповаяСтруктура = Новый Структура;

	ТиповаяСтруктура.Вставить("Заголовок",						?(ПустаяСтрока(Заголовок), ЗаголовокПоУмолчанию(), Заголовок));
	ТиповаяСтруктура.Вставить("Каталог", 						?(ПустаяСтрока(Каталог), "", Каталог));
	ТиповаяСтруктура.Вставить("МножественныйВыбор", 			МножественныйВыбор);
	ТиповаяСтруктура.Вставить("ПолноеИмяФайла", 				?(ПустаяСтрока(ПолноеИмяФайла), "", ПолноеИмяФайла));
	ТиповаяСтруктура.Вставить("ПредварительныеПросмотр", 		Истина);
	ТиповаяСтруктура.Вставить("ПроверятьСуществованиеФайла", 	Истина);
	ТиповаяСтруктура.Вставить("Фильтр", 						?(ПустаяСтрока(Фильтр), "Все файлы (*.*)|*.*", Фильтр));

	Возврат ТиповаяСтруктура;

КонецФункции

&НаКлиенте
Функция ЗаголовокПоУмолчанию()

	Возврат "Vanessa.ADD";

КонецФункции // Контур_ЗаголовокПоУмолчанию()


#КонецОбласти

#Область ОписанияОповещения

&НаКлиенте
Функция смв_НовыйОписаниеОповещения(ИмяПроцедуры, Модуль, ДополнительныеПараметры = Неопределено, ИмяПроцедурыОбработкиОшибки = "", МодульОбработкиОшибки = Неопределено) Экспорт

	#Если ВебКлиент Тогда

		Возврат Новый ОписаниеОповещения(ИмяПроцедуры, Модуль, ДополнительныеПараметры);

	#Иначе

		Если МодальностьЗапрещена Тогда
			Возврат Вычислить("Новый ОписаниеОповещения(ИмяПроцедуры, Модуль, ДополнительныеПараметры)");
			// С ошибками пока не будем бороться, были какие-то сложности с типом параметров
		Иначе
			Возврат Новый Структура("ИмяПроцедуры, Модуль, ДополнительныеПараметры, ИмяПроцедурыОбработкиОшибки, МодульОбработкиОшибки"
									, ИмяПроцедуры, Модуль, ДополнительныеПараметры, ИмяПроцедурыОбработкиОшибки, МодульОбработкиОшибки);
		КонецЕсли;

	#КонецЕсли

КонецФункции

&НаКлиенте
Процедура смв_ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат = Неопределено, КоличествоПараметровОбработчика = 2) Экспорт

	Если ОписаниеОповещения = Неопределено Тогда
		Возврат;
	КонецЕсли;

	#Если ВебКлиент Тогда

		ВыполнитьОбработкуОповещения(ОписаниеОповещения);

	#Иначе

		Если МодальностьЗапрещена Тогда
			Если КоличествоПараметровОбработчика = 2 Тогда
				Выполнить("ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат)");
			ИначеЕсли КоличествоПараметровОбработчика = 1 Тогда
				Выполнить("ВыполнитьОбработкуОповещения(ОписаниеОповещения)");
			КонецЕсли;
		Иначе
			// Если модальность не запрещена, то в ОписаниеОповещения у нас будет Структура
			Если КоличествоПараметровОбработчика = 2 Тогда
				Выполнить("ОписаниеОповещения.Модуль." + ОписаниеОповещения.ИмяПроцедуры + "(Результат, ОписаниеОповещения.ДополнительныеПараметры)");
			ИначеЕсли КоличествоПараметровОбработчика = 1 Тогда
				Выполнить("ОписаниеОповещения.Модуль." + ОписаниеОповещения.ИмяПроцедуры + "(ОписаниеОповещения.ДополнительныеПараметры)");
			КонецЕсли;
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура смв_ОткрытьФорму(ИмяФормы
							, ПараметрыФормы = Неопределено
							, Владелец = Неопределено
							, Уникальность = Ложь
							, Окно = Неопределено
							, НавигационнаяСсылка = Неопределено
							, ОписаниеОповещенияОЗакрытии = Неопределено
							, РежимОткрытияОкна = Неопределено)  Экспорт


	// Синтаксис из 8.2.9 и 8.2.19:

	// ОткрытьФорму(<ИмяФормы>, <Параметры>, <Владелец>, <Уникальность>, <Окно>)

	// Т.е. отсутствуют последние 3 параметра - а в них и РежимОткрытияОкна, и ОписаниеОповещенияОЗакрытии.
	// Значит, тут нам надо понять - открывать ли форму модально там, где запрета на модальность еще нет


	// Теперь варианты РежимОткрытияОкнаФормы в 8.2.9:
	// БлокироватьОкноВладельца (LockOwnerWindow)
	// Независимый (Independent)

	Если Найти(ИмяФормы, ".") = 0 Тогда

		ИмяФормы = ВладелецФормы.ПутьКФормам + ИмяФормы;

	КонецЕсли;

	Если НЕ МодальностьЗапрещена Тогда

		ОткрыватьМодально = Истина;

		Если РежимОткрытияОкна = Неопределено
			Или РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый Тогда

			ОткрыватьМодально = Ложь;

		КонецЕсли;

	КонецЕсли;

	#Если ВебКлиент Тогда

		ОткрытьФорму(ИмяФормы, ПараметрыФормы, Владелец, Уникальность, , ,  ОписаниеОповещенияОЗакрытии, РежимОткрытияОкна);

	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("ОткрытьФорму(ИмяФормы, ПараметрыФормы, Владелец, Уникальность, Окно, ,  ОписаниеОповещенияОЗакрытии, РежимОткрытияОкна)");

		Иначе

			Если ОткрыватьМодально Тогда
				РезультатОткрытия = Вычислить("ОткрытьФормуМодально(ИмяФормы, ПараметрыФормы, Владелец)");
				смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, РезультатОткрытия);
			Иначе
				Выполнить("ОткрытьФорму(ИмяФормы, ПараметрыФормы, Владелец, Уникальность, Окно)");
			КонецЕсли;

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Функция смв_ПустоеОповещение() Экспорт

	Возврат смв_НовыйОписаниеОповещения("ПустоеОповещение", ЭтаФорма);

КонецФункции


#Область Модальные_диалоги

&НаКлиенте
Процедура смв_ПоказатьПредупреждение(ОписаниеОповещенияОЗавершении = Неопределено, ТекстПредупреждения = Неопределено, Таймаут = 30, Заголовок = "") Экспорт
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = ЗаголовокПоУмолчанию();
	КонецЕсли;
	#Если ВебКлиент Тогда

		ПоказатьПредупреждение(ОписаниеОповещенияОЗавершении, ТекстПредупреждения, Таймаут, Заголовок);

	#Иначе

		Если МодальностьЗапрещена Тогда
			Выполнить("ПоказатьПредупреждение(ОписаниеОповещенияОЗавершении, ТекстПредупреждения, Таймаут, Заголовок)");
		Иначе
			Выполнить("Предупреждение(ТекстПредупреждения, Таймаут, Заголовок)");
			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, , 1);
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПоказатьВопрос(ОписаниеОповещенияОЗавершении,
							 ТекстВопроса,
							 Кнопки,
							 Таймаут = 0,
							 КнопкаПоУмолчанию = Неопределено,
							 Заголовок = "",
							 КнопкаТаймаута = Неопределено) Экспорт

	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = ЗаголовокПоУмолчанию();
	КонецЕсли;
	#Если ВебКлиент Тогда
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, Кнопки, Таймаут, КнопкаПоУмолчанию, Заголовок, КнопкаТаймаута);
	#Иначе
		Если МодальностьЗапрещена Тогда
			Выполнить("ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, Кнопки, Таймаут, КнопкаПоУмолчанию, Заголовок, КнопкаТаймаута)");
		Иначе
			Ответ = Вопрос(ТекстВопроса, Кнопки, Таймаут, КнопкаПоУмолчанию, Заголовок, КнопкаТаймаута);
			Выполнить("ОписаниеОповещенияОЗавершении.Модуль." + ОписаниеОповещенияОЗавершении.ИмяПроцедуры + "(Ответ, ОписаниеОповещенияОЗавершении.ДополнительныеПараметры)");
		КонецЕсли;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПоказатьЗначение(ОписаниеОповещенияОЗавершении = Неопределено, Значение = Неопределено) Экспорт

	#Если ВебКлиент Тогда

		ПоказатьЗначение(ОписаниеОповещенияОЗавершении, Значение);

	#Иначе

		Если МодальностьЗапрещена Тогда
			Выполнить("ПоказатьЗначение(ОписаниеОповещенияОЗавершении, Значение)");
		Иначе
			Выполнить("ОткрытьЗначение(Значение)");
			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении);
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПоказатьВводСтроки(ОписаниеОповещенияОЗавершении,
							 Строка = "",
							 Подсказка = "",
							 Длина = 0,
							 Многострочность = Ложь) Экспорт

	#Если ВебКлиент Тогда
		ПоказатьВводСтроки(ОписаниеОповещенияОЗавершении, Строка, Подсказка, Длина, Многострочность);
	#Иначе
		Если МодальностьЗапрещена Тогда
			Выполнить("ПоказатьВводСтроки(ОписаниеОповещенияОЗавершении, Строка, Подсказка, Длина, Многострочность)");
		Иначе
			Если ВвестиСтроку(Строка, Подсказка, Длина, Многострочность) Тогда

				// Здесь необходимо убедиться, что в строку не был передан вредоносный код
				// Поскольку в 8.2.19 она будет направлена в Выполнить()
				// UPD кажется, это в данном случае не имеет смысла.
				// Если смв_СтрокуДопустимоПередаватьВОбработчикВыполнения(Строка) Тогда
					смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Строка);
				// Иначе
				//	ВызватьИсключение "Некорректно введена строка";
				// КонецЕсли;

			КонецЕсли;
		КонецЕсли;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПоказатьВводДаты(ОписаниеОповещенияОЗавершении,
							 ВыбраннаяДата = "",
							 Подсказка = "",
							 ЧастьДаты = Неопределено) Экспорт

	#Если ВебКлиент Тогда
		ПоказатьВводДаты(ОписаниеОповещенияОЗавершении, ВыбраннаяДата, Подсказка, ЧастьДаты);
	#Иначе
		Если МодальностьЗапрещена Тогда
			Выполнить("ПоказатьВводДаты(ОписаниеОповещенияОЗавершении, ВыбраннаяДата, Подсказка, ЧастьДаты)");
		Иначе
			Если ВвестиДату(ВыбраннаяДата, Подсказка, ЧастьДаты) Тогда
				смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, ВыбраннаяДата);
			КонецЕсли;
		КонецЕсли;
	#КонецЕсли

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура смв_ПоказатьВыборЭлемента(ОписаниеОповещенияОЗавершении, Список, Заголовок = "", Элемент = Неопределено) Экспорт

	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = ЗаголовокПоУмолчанию();
	КонецЕсли;

	#Если ВебКлиент Тогда

		Список.ПоказатьВыборЭлемента(ОписаниеОповещенияОЗавершении, Заголовок, Элемент);

	#Иначе

		Если МодальностьЗапрещена Тогда
			Выполнить("Список.ПоказатьВыборЭлемента(ОписаниеОповещенияОЗавершении, Заголовок, Элемент)");
		Иначе
			ВыбранныйЭлемент = Вычислить("Список.ВыбратьЭлемент(Заголовок, Элемент)");
			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, ВыбранныйЭлемент, 2);
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_Форма_ПоказатьВыборИзМеню(Форма, ОписаниеОповещенияОЗавершении, СписокЗначений, ЭлементФормы = Неопределено, НачальноеЗначение = Неопределено) Экспорт

	#Если ВебКлиент Тогда

		Форма.ПоказатьВыборИзМеню(ОписаниеОповещенияОЗавершении, СписокЗначений, ЭлементФормы);

	#Иначе

		Если МодальностьЗапрещена Тогда
			Выполнить("Форма.ПоказатьВыборИзМеню(ОписаниеОповещенияОЗавершении, СписокЗначений, ЭлементФормы)");  // вроде бы после 8.3.7, ПоказатьВыборИзМеню глючит - надо бы проверить.
		Иначе
			ВыбранноеЗначение = Форма.ВыбратьИзМеню(СписокЗначений, ЭлементФормы);
			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, ВыбранноеЗначение);
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ДиалогРедактированияСтандартногоПериода_Показать(Диалог, ОписаниеОповещения) Экспорт

	#Если ВебКлиент Тогда

		Диалог.Показать(ОписаниеОповещения);

	#Иначе

		Если МодальностьЗапрещена Тогда
			Выполнить("Диалог.Показать(ОписаниеОповещения)");
		Иначе
			Если Диалог.Редактировать() Тогда
				смв_ВыполнитьОбработкуОповещения(ОписаниеОповещения, Диалог.Период);
			КонецЕсли;
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

#Область Диалог_выбора_файла

&НаКлиенте
Процедура смв_ПоказатьДиалогВыбораКаталога(ОписаниеОповещенияОЗавершении,
											Заголовок	= "",
											Каталог		= "",
											МножественныйВыбор = Ложь) Экспорт

	ПараметрыДиалога = ТиповаяСтруктураДиалогаВыбораФайла(Заголовок, Каталог, МножественныйВыбор);

	смв_ПоказатьДиалогВыбораФайла(ОписаниеОповещенияОЗавершении,
									РежимДиалогаВыбораФайла.ВыборКаталога,
									ПараметрыДиалога);
КонецПроцедуры

&НаКлиенте
Процедура смв_ПоказатьДиалогОткрытие(ОписаниеОповещенияОЗавершении,
											Фильтр				= Неопределено,
											Заголовок			= Неопределено,
                                            Каталог				= Неопределено,
											ПолноеИмяФайла		= Неопределено,
											МножественныйВыбор	= Ложь) Экспорт

	ПараметрыДиалога = ТиповаяСтруктураДиалогаВыбораФайла(Заголовок, Каталог, МножественныйВыбор, ПолноеИмяФайла, Фильтр);

	смв_ПоказатьДиалогВыбораФайла(ОписаниеОповещенияОЗавершении,
									РежимДиалогаВыбораФайла.Открытие,
									ПараметрыДиалога);
КонецПроцедуры

&НаКлиенте
Процедура смв_ПоказатьДиалогСохранение(ОписаниеОповещенияОЗавершении,
											Фильтр				= Неопределено,
											Заголовок			= Неопределено,
                                            Каталог				= Неопределено,
											ПолноеИмяФайла		= Неопределено) Экспорт

	ПараметрыДиалога = ТиповаяСтруктураДиалогаВыбораФайла(Заголовок, Каталог, Ложь, ПолноеИмяФайла, Фильтр);

	смв_ПоказатьДиалогВыбораФайла(ОписаниеОповещенияОЗавершении,
									РежимДиалогаВыбораФайла.Сохранение,
									ПараметрыДиалога);

КонецПроцедуры

&НаКлиенте
Процедура смв_ПоказатьДиалогВыбораФайла(ОписаниеОповещенияОЗавершении,
											РежимРаботы,
											ПараметрыВыбора)
	Диалог = Новый ДиалогВыбораФайла(РежимРаботы);
	ЗаполнитьЗначенияСвойств(Диалог, ПараметрыВыбора);
	#Если ВебКлиент Тогда
		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			Диалог.Показать(ОписаниеОповещенияОЗавершении);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;
	#Иначе
		Если МодальностьЗапрещена Тогда
			Выполнить("Диалог.Показать(ОписаниеОповещенияОЗавершении)");
		ИначеЕсли Диалог.Выбрать() Тогда
			Результат = Новый Массив;

			Если РежимРаботы = РежимДиалогаВыбораФайла.ВыборКаталога Тогда
				Результат.Добавить(Диалог.Каталог);
			Иначе
				Для Каждого Файл Из Диалог.ВыбранныеФайлы Цикл
					Результат.Добавить(Файл);
				КонецЦикла;
			КонецЕсли;

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Результат);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры


#КонецОбласти

&НаСервере
Процедура ЗаписьЖурналаРегистрацииСервер(Сообщение)
	ЗаписьЖурналаРегистрации("Отладка",,,,Сообщение);
КонецПроцедуры

#Область Получение_Помещение_файлов

&НаКлиенте
Процедура смв_ПоместитьФайлы(ОписаниеОповещенияОЗавершении,
										ПомещаемыеФайлы) Экспорт

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			НачатьПомещениеФайлов(ОписаниеОповещенияОЗавершении, ПомещаемыеФайлы, , Ложь, ВладелецФормы.УникальныйИдентификатор);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		ПомещенныеФайлы = Новый Массив;

		Если ПомещаемыеФайлы.Количество() = 0 Тогда

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, ПомещенныеФайлы);

		ИначеЕсли МодальностьЗапрещена Тогда

			Выполнить("НачатьПомещениеФайлов(ОписаниеОповещенияОЗавершении, ПомещаемыеФайлы, , Ложь, ВладелецФормы.УникальныйИдентификатор)");

		ИначеЕсли ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь, ВладелецФормы.УникальныйИдентификатор) Тогда

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, ПомещенныеФайлы);

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПоместитьФайлыЧерезДиалог(ОписаниеОповещенияОЗавершении,
											Фильтр				= Неопределено,
											Заголовок			= Неопределено,
                                            Каталог				= Неопределено,
											ПолноеИмяФайла		= Неопределено,
											МножественныйВыбор	= Ложь) Экспорт

	ПараметрыДиалога	= ТиповаяСтруктураДиалогаВыбораФайла(Заголовок, Каталог, МножественныйВыбор, ПолноеИмяФайла, Фильтр);
	ДиалогОткрытияФайла	= Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ЗаполнитьЗначенияСвойств(ДиалогОткрытияФайла, ПараметрыДиалога);
	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			НачатьПомещениеФайлов(ОписаниеОповещенияОЗавершении, , ДиалогОткрытияФайла, Истина, ВладелецФормы.УникальныйИдентификатор);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		ПомещенныеФайлы = Новый Массив;

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьПомещениеФайлов(ОписаниеОповещенияОЗавершении, , ДиалогОткрытияФайла, Истина, ВладелецФормы.УникальныйИдентификатор);");

		ИначеЕсли ПоместитьФайлы(, ПомещенныеФайлы, ДиалогОткрытияФайла, Истина, ВладелецФормы.УникальныйИдентификатор) Тогда

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, ПомещенныеФайлы);

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПоместитьФайл(ОписаниеОповещенияОЗавершении,
								АдресХранения, Знач ПомещаемыйФайл, Интерактивно = Ложь) Экспорт

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			НачатьПомещениеФайла(ОписаниеОповещенияОЗавершении, АдресХранения, ПомещаемыйФайл, Интерактивно, ВладелецФормы.УникальныйИдентификатор);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьПомещениеФайла(ОписаниеОповещенияОЗавершении, АдресХранения, ПомещаемыйФайл, Интерактивно, ВладелецФормы.УникальныйИдентификатор)");

		ИначеЕсли ПоместитьФайл(АдресХранения, ПомещаемыйФайл, ПомещаемыйФайл, Интерактивно, ВладелецФормы.УникальныйИдентификатор) Тогда

			Выполнить("ОписаниеОповещенияОЗавершении.Модуль." + ОписаниеОповещенияОЗавершении.ИмяПроцедуры + "(Истина, АдресХранения, ПомещаемыйФайл, ОписаниеОповещенияОЗавершении.ДополнительныеПараметры)");
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПолучитьФайлы(ОписаниеОповещенияОЗавершении,
										СохраняемыеФайлы,
										КаталогСохранения) Экспорт

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			НачатьПолучениеФайлов(ОписаниеОповещенияОЗавершении, СохраняемыеФайлы, КаталогСохранения, Ложь);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		СохраненныеФайлы = Новый Массив;

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьПолучениеФайлов(ОписаниеОповещенияОЗавершении, СохраняемыеФайлы, КаталогСохранения, Ложь)");

		ИначеЕсли ПолучитьФайлы(СохраняемыеФайлы, СохраненныеФайлы, КаталогСохранения, Ложь) Тогда

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, СохраненныеФайлы);

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПолучитьФайлыЧерезДиалог(ОписаниеОповещенияОЗавершении,
										СохраняемыеФайлы,
										Заголовок	= "",
										Каталог		= ""
										) Экспорт

	Если СохраняемыеФайлы.Количество() = 1 Тогда

		ТестФайл	= Новый Файл(СохраняемыеФайлы[0].Имя);
		Расширение	= СтрЗаменить(ВРег(ТестФайл.Расширение), ".", "");
		Фильтр		= СформироватьСтрокуФильтраПоРасширению(Расширение);

		ПараметрыДиалога	= ТиповаяСтруктураДиалогаВыбораФайла(Заголовок, Каталог, Ложь, ТестФайл.Имя, Фильтр);
		ДиалогВыбораКаталог	= Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);

	Иначе

		ПараметрыДиалога	= ТиповаяСтруктураДиалогаВыбораФайла(Заголовок, Каталог);
		ДиалогВыбораКаталог	= Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);

	КонецЕсли;

	ЗаполнитьЗначенияСвойств(ДиалогВыбораКаталог, ПараметрыДиалога);

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			НачатьПолучениеФайлов(ОписаниеОповещенияОЗавершении, СохраняемыеФайлы, ДиалогВыбораКаталог, Истина);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		СохраненныеФайлы = Новый Массив;

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьПолучениеФайлов(ОписаниеОповещенияОЗавершении, СохраняемыеФайлы, ДиалогВыбораКаталог, Истина)");

		ИначеЕсли ПолучитьФайлы(СохраняемыеФайлы, СохраненныеФайлы, ДиалогВыбораКаталог, Истина) Тогда

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, СохраненныеФайлы);

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПолучитьФайлыВоВременныйКаталог(ОписаниеОповещенияОЗавершении,
										СохраняемыеФайлы) Экспорт

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДанныеДляСохранения",				СохраняемыеФайлы);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершенияСохранения",	ОписаниеОповещенияОЗавершении);

	ОписаниеОповещения = смв_НовыйОписаниеОповещения("ПолучениеКаталогаВременныхФайловДляСохраненияЗавершение", ЭтаФорма, ДополнительныеПараметры);

	смв_КаталогВременныхФайлов(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Функция НовыйОписаниеПередаваемогоФайла(ИмяФайла, ДанныеДляПередачи) Экспорт

	Адрес = ПоместитьВоВременноеХранилище(ДанныеДляПередачи, ВладелецФормы.УникальныйИдентификатор);

	Возврат Новый ОписаниеПередаваемогоФайла(ИмяФайла, Адрес);

КонецФункции

#КонецОбласти

&НаКлиенте
Процедура смв_ЗапуститьПриложение(ОписаниеОповещенияОЗавершении,
									СтрокаЗапускаПриложения,
									ТекущийКаталог		= "",
									ДождатьсяЗавершения = Ложь,
									КодВозврата			= Неопределено) Экспорт

	#Если ВебКлиент Тогда

		НачатьЗапускПриложения(ОписаниеОповещенияОЗавершении, СтрокаЗапускаПриложения, ТекущийКаталог, ДождатьсяЗавершения);

	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьЗапускПриложения(ОписаниеОповещенияОЗавершении, СтрокаЗапускаПриложения, ТекущийКаталог, ДождатьсяЗавершения)");

		Иначе

			ЗапуститьПриложение(СтрокаЗапускаПриложения, ТекущийКаталог, ДождатьсяЗавершения, КодВозврата);
			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, КодВозврата);

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_УстановитьРасширениеРаботыСФайлами(ОписаниеОповещенияОЗавершении = Неопределено) Экспорт

	#Если ВебКлиент Тогда


		НачатьУстановкуРасширенияРаботыСФайлами(ОписаниеОповещенияОЗавершении);

	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьУстановкуРасширенияРаботыСФайлами(ОписаниеОповещенияОЗавершении)");

		Иначе

			УстановитьРасширениеРаботыСФайлами();
			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении);

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_ПодключитьРасширениеРаботыСФайлами(ОписаниеОповещенияОЗавершении = Неопределено) Экспорт

	#Если ВебКлиент Тогда


		НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещенияОЗавершении);

	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещенияОЗавершении)");

		Иначе

			ПодключитьРасширениеРаботыСФайлами();
			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении);

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

#Область Операции_с_файлами

&НаКлиенте
Процедура смв_НайтиФайлы(ОписаниеОповещенияОЗавершении, Путь, Маска = Неопределено, ИскатьВПодкаталогах = Ложь) Экспорт

	#Если ВебКлиент Тогда

		НачатьПоискФайлов(ОписаниеОповещенияОЗавершении, Путь, Маска, ИскатьВПодкаталогах);

	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьПоискФайлов(ОписаниеОповещенияОЗавершении, Путь, Маска, ИскатьВПодкаталогах)");

		Иначе

			Результат = НайтиФайлы(Путь, Маска, ИскатьВПодкаталогах);
			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Результат);

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_КаталогВременныхФайлов(ОписаниеОповещенияОЗавершении) Экспорт

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			НачатьПолучениеКаталогаВременныхФайлов(ОписаниеОповещенияОЗавершении);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("НачатьПолучениеКаталогаВременныхФайлов(ОписаниеОповещенияОЗавершении)");

		Иначе

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, КаталогВременныхФайлов());

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_Файл_ПолучитьВремяИзменения(Файл, ОписаниеОповещенияОЗавершении) Экспорт

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			Файл.НачатьПолучениеВремениИзменения(ОписаниеОповещенияОЗавершении);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("Файл.НачатьПолучениеВремениИзменения(ОписаниеОповещенияОЗавершении)");

		Иначе

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Файл.ПолучитьВремяИзменения());

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_Файл_Существует(Файл, ОписаниеОповещенияОЗавершении) Экспорт

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			Файл.НачатьПроверкуСуществования (ОписаниеОповещенияОЗавершении);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("Файл.НачатьПроверкуСуществования (ОписаниеОповещенияОЗавершении)");

		Иначе

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Файл.Существует());

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_Файл_ЭтоФайл(Файл, ОписаниеОповещенияОЗавершении) Экспорт

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			Файл.НачатьПроверкуЭтоФайл(ОписаниеОповещенияОЗавершении);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("Файл.НачатьПроверкуЭтоФайл(ОписаниеОповещенияОЗавершении)");

		Иначе

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Файл.ЭтоФайл());

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура смв_Файл_ЭтоКаталог(Файл, ОписаниеОповещенияОЗавершении) Экспорт

	#Если ВебКлиент Тогда

		Если ПроверитьРасширениеРаботыСФайламиВебКлиент() Тогда

			Файл.НачатьПроверкуЭтоКаталог(ОписаниеОповещенияОЗавершении);

		Иначе

			смв_ПоказатьПредупреждение(, "Не подключено Расширения для работы с файлами. Обратитесь к администратору для решения проблемы.", 30);

		КонецЕсли;


	#Иначе

		Если МодальностьЗапрещена Тогда

			Выполнить("Файл.НачатьПроверкуЭтоКаталог(ОписаниеОповещенияОЗавершении)");

		Иначе

			смв_ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Файл.ЭтоКаталог());

		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область Инициализация_плагинов

&НаКлиенте
Функция СтроковыеУтилиты()

	Если СтроковыеУтилиты = Неопределено Тогда

		СтроковыеУтилиты = ВладелецФормы.Плагин("СтроковыеУтилиты");

	КонецЕсли;

	Возврат СтроковыеУтилиты;

КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина;
КонецПроцедуры
