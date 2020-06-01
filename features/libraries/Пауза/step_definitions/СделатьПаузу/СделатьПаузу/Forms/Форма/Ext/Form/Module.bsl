﻿//начало текста модуля

&НаКлиенте
Перем КолСекундОжидания;
&НаКлиенте
Перем ПрошлоСекунд;

///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-ADD
Перем Ванесса;

&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;

&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-ADD.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;

	ВсеТесты = Новый Массив;

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯДелаюПаузуСекунды(Парам01)","ЯДелаюПаузуСекунды","Когда Я делаю паузу 2 секунды");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"Пауза(Парам01)","Пауза","И     Пауза 1","Позволяет сделать паузу нужной длительности.","Прочее.Сделать паузу");

	Возврат ВсеТесты;
КонецФункции

&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции

&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции

///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
Процедура ОбработчикОжидания()
	ИмяОбработчика = "ОбработчикОжидания";

	Если (ТекущаяДата() - ДатаНачалаОбработкиОжидания) >= КоличествоСекундОбработкаОжидания Тогда
		ОтключитьОбработчикОжидания(ИмяОбработчика);
		Ванесса.ПродолжитьВыполнениеШагов();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
//Когда Я делаю паузу 2 секунды
//@ЯДелаюПаузуСекунды(Парам01)
Процедура ЯДелаюПаузуСекунды(КолСекунд) Экспорт

    Пауза(КолСекунд);

КонецПроцедуры

&НаКлиенте
//И Пауза 1
//@Пауза(Парам01)
Процедура Пауза(КолСекунд) Экспорт

	Если КонтекстСохраняемый.Свойство("ТестовоеПриложение") Тогда

		ДатаНачалаОбработкиОжидания       = ТекущаяДата();
		КоличествоСекундОбработкаОжидания = Ванесса.ЗначениеТаймаутаДляАсинхронногоШага(КолСекунд);

		ЗаголовокПауза = Строка(Новый УникальныйИдентификатор);
		Пока  (ТекущаяДата() - ДатаНачалаОбработкиОжидания) < КоличествоСекундОбработкаОжидания Цикл

			КонтекстСохраняемый.ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"),
				ЗаголовокПауза, ЗаголовокПауза, 1);

		КонецЦикла;

		Возврат;

	КонецЕсли;

	Ванесса.ЗапретитьВыполнениеШагов();

	КоличествоСекундОбработкаОжидания = КолСекунд;
	ДатаНачалаОбработкиОжидания       = ТекущаяДата();

	ПодключитьОбработчикОжидания("ОбработчикОжидания", 1, Ложь);
КонецПроцедуры

//окончание текста модуля