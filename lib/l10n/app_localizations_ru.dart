// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Too Good To Go';

  @override
  String hello(String name) {
    return 'Привет, $name!';
  }

  @override
  String get searchMagicBags => 'Поиск волшебных пакетов...';

  @override
  String get nearby => 'Рядом';

  @override
  String get favorites => 'Избранное';

  @override
  String get all => 'Все';

  @override
  String get bakery => 'Пекарня';

  @override
  String get restaurant => 'Ресторан';

  @override
  String get cafe => 'Кафе';

  @override
  String get grocery => 'Продуктовый магазин';

  @override
  String get convenience => 'Удобство';

  @override
  String get other => 'Другое';

  @override
  String get available => 'Доступно';

  @override
  String get soldOut => 'Распродано';

  @override
  String get pickup => 'Получение';

  @override
  String get location => 'Местоположение';

  @override
  String get rating => 'Рейтинг';

  @override
  String get discount => 'Скидка';

  @override
  String get originalPrice => 'Исходная цена';

  @override
  String get discountedPrice => 'Цена со скидкой';

  @override
  String get more => 'еще';

  @override
  String get login => 'Войти';

  @override
  String get signup => 'Зарегистрироваться';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get signUpWithGoogle => 'Зарегистрироваться через Google';

  @override
  String get customer => 'Клиент';

  @override
  String get vendor => 'Продавец';

  @override
  String get userType => 'Тип пользователя';

  @override
  String get name => 'Имя';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get businessName => 'Название бизнеса';

  @override
  String get businessDescription => 'Описание бизнеса';

  @override
  String get businessCategory => 'Категория бизнеса';

  @override
  String get createMagicBag => 'Создать волшебный пакет';

  @override
  String get editMagicBag => 'Редактировать волшебный пакет';

  @override
  String get title => 'Название';

  @override
  String get description => 'Описание';

  @override
  String get foodItems => 'Продукты питания';

  @override
  String get addFoodItem => 'Добавить продукт';

  @override
  String get images => 'Изображения';

  @override
  String get addImage => 'Добавить изображение';

  @override
  String get quantity => 'Количество';

  @override
  String get availableQuantity => 'Доступное количество';

  @override
  String get category => 'Категория';

  @override
  String get pickupStartTime => 'Время начала получения';

  @override
  String get pickupEndTime => 'Время окончания получения';

  @override
  String get expiresAt => 'Истекает в';

  @override
  String get address => 'Адрес';

  @override
  String get allergens => 'Аллергены';

  @override
  String get addAllergen => 'Добавить аллерген';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get view => 'Просмотр';

  @override
  String get order => 'Заказ';

  @override
  String get orders => 'Заказы';

  @override
  String get orderHistory => 'История заказов';

  @override
  String get orderDetails => 'Детали заказа';

  @override
  String get orderStatus => 'Статус заказа';

  @override
  String get paymentStatus => 'Статус оплаты';

  @override
  String get totalAmount => 'Общая сумма';

  @override
  String get discountAmount => 'Сумма скидки';

  @override
  String get pickupCode => 'Код получения';

  @override
  String get orderDate => 'Дата заказа';

  @override
  String get pickedUpAt => 'Получено в';

  @override
  String get cancelledAt => 'Отменено в';

  @override
  String get cancellationReason => 'Причина отмены';

  @override
  String get pending => 'В ожидании';

  @override
  String get confirmed => 'Подтверждено';

  @override
  String get ready => 'Готово';

  @override
  String get pickedUp => 'Получено';

  @override
  String get cancelled => 'Отменено';

  @override
  String get completed => 'Завершено';

  @override
  String get paid => 'Оплачено';

  @override
  String get failed => 'Неудачно';

  @override
  String get refunded => 'Возвращено';

  @override
  String get profile => 'Профиль';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get english => 'Английский';

  @override
  String get russian => 'Русский';

  @override
  String get azerbaijani => 'Азербайджанский';

  @override
  String get home => 'Главная';

  @override
  String get map => 'Карта';

  @override
  String get noMagicBagsFound => 'Волшебные пакеты не найдены';

  @override
  String get tryAdjustingFilters => 'Попробуйте изменить фильтры или поисковые запросы';

  @override
  String get logout => 'Выйти';

  @override
  String get accountSettings => 'Настройки аккаунта';

  @override
  String get notifications => 'Уведомления';

  @override
  String get help => 'Помощь';

  @override
  String get about => 'О приложении';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get contactUs => 'Связаться с нами';

  @override
  String get version => 'Версия';

  @override
  String get buildNumber => 'Номер сборки';

  @override
  String get errorLoadingMagicBags => 'Ошибка загрузки волшебных пакетов';

  @override
  String get databaseSeededSuccessfully => 'База данных успешно заполнена!';

  @override
  String get errorSeedingDatabase => 'Ошибка заполнения базы данных';

  @override
  String get seedDatabase => 'Заполнить базу данных';

  @override
  String get filterByCategory => 'Фильтр по категории';

  @override
  String get selectCategory => 'Выберите категорию';

  @override
  String get clear => 'Очистить';

  @override
  String get noDataAvailable => 'Данные недоступны';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get success => 'Успех';

  @override
  String get warning => 'Предупреждение';

  @override
  String get info => 'Информация';

  @override
  String get noFavoriteVendorsYet => 'Пока нет избранных продавцов';

  @override
  String get startAddingVendorsToFavorites => 'Начните добавлять продавцов в избранное,\nчтобы увидеть их здесь';

  @override
  String get exploreVendors => 'Исследовать продавцов';

  @override
  String get manageNotifications => 'Управление уведомлениями';

  @override
  String get privacySecurity => 'Конфиденциальность и безопасность';

  @override
  String get managePrivacySettings => 'Управление настройками конфиденциальности';

  @override
  String get account => 'Аккаунт';

  @override
  String get helpSupport => 'Помощь и поддержка';

  @override
  String get getHelpContactSupport => 'Получить помощь и связаться с поддержкой';

  @override
  String get appVersionInformation => 'Версия приложения и информация';

  @override
  String get signOut => 'Выйти';

  @override
  String get signOutAccount => 'Выйти из аккаунта';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get areYouSureSignOut => 'Вы уверены, что хотите выйти?';

  @override
  String get mapView => 'Карта';

  @override
  String get vendorList => 'Список продавцов';

  @override
  String get noVendorsFound => 'Продавцы не найдены';

  @override
  String get tryAdjustingLocation => 'Попробуйте изменить местоположение или фильтры';
}
