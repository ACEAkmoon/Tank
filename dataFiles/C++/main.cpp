#include <QApplication>
#include <QQmlEngine>
#include <QDebug>
#include <QFont>
#include <QQmlContext>
#include <QQmlComponent>
#include <QSoundEffect>


//Підключаєм QML
int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlEngine engine;
    QQmlComponent component(&engine, QUrl(QStringLiteral("qrc:/dataFiles/QML/main.qml")));
    component.create();
    QObject::connect(engine.rootContext()->engine(), SIGNAL(quit()), qApp, SLOT(quit()));
    return app.exec();
}
