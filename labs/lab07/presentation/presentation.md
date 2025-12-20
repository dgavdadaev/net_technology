---
lang: ru-RU
title: Лабораторная работа №7
subtitle: Адресация IPv4 и IPv6. Настройка DHCP / DHCPv6
author:
  - Авдадаев Джамал Геланиевич
date: 20 декабря 2025
aspectratio: 169
slide_level: 2
section-titles: true
theme: metropolis
---

# Цель работы

## Цель

Получить навыки настройки службы DHCP на сетевом оборудовании для распределения адресов IPv4 и IPv6:

- DHCP (IPv4)
- DHCPv6 Stateless (SLAAC + доп. параметры)
- DHCPv6 Stateful (выдача IPv6-адресов)

# DHCP для IPv4

## Топология IPv4

- Сегмент: PC1 → sw-01 → gw-01
- Шлюз: 10.0.0.1/24
- Клиент получает параметры по DHCP

![Топология сети в GNS3](Screenshot_1.png){ width=78% }

## Базовая настройка VyOS

- Заданы host-name и domain-name
- Создан пользователь dgavdadaev
- Отключён DHCP на eth0

![Базовая системная настройка VyOS](Screenshot_2.png){ width=78% }

## Адресация и DHCP-сервер (IPv4)

- eth0: 10.0.0.1/24
- Пул: 10.0.0.2–10.0.0.253
- DNS/Router: 10.0.0.1

![Настройка адресации и DHCP-сервера на VyOS](Screenshot_3.png){ width=78% }

## Получение параметров на PC1 (DHCP)

- Назначен IP: 10.0.0.2/24
- Lease Time: 86400 секунд
- Выданы: DNS, шлюз, домен

![Получение параметров по DHCP на VPCS](Screenshot_4.png){ width=78% }

## Проверка конфигурации и связности

- show ip подтверждает параметры
- Шлюз: 10.0.0.1
- ping 10.0.0.1 успешен

![Проверка IPv4-параметров и ping маршрутизатора](Screenshot_5.png){ width=78% }

## DHCP-статистика и аренды (VyOS)

- Pool size: 252
- Active leases: 1
- Клиент: 10.0.0.2 (VPCS)

![Статистика DHCP-сервера и активные аренды](Screenshot_6.png){ width=78% }

## Лог DHCP-сервера

- Discover → Offer
- Request → ACK
- Назначение адреса подтверждено

![Журнал работы DHCP-сервера](Screenshot_7.png){ width=78% }

## Анализ DHCP-трафика (Wireshark)

- Последовательность DORA
- Опции: mask/router/DNS/domain/lease
- Корректная выдача параметров

![DHCP в Wireshark](Screenshot_8.png){ width=78% }

# DHCPv6 Stateless

## Расширенная топология для IPv6

- Добавлены сегменты через sw-02 и sw-03
- Клиенты: PC2 и PC3 (Kali Linux CLI)
- Захват трафика на линиях gw-01—sw-02 и gw-01—sw-03

![Топология IPv6](Screenshot_9.png){ width=78% }

## IPv6-адресация интерфейсов VyOS

- eth1: 2000::1/64
- eth2: 2001::1/64
- Проверка через show interfaces

![Назначение IPv6 на eth1/eth2](Screenshot_10.png){ width=78% }

## Stateless: RA + DHCPv6 (настройка)

- RA prefix 2000::/64 (eth1)
- other-config-flag: доп. параметры через DHCPv6
- DHCPv6: DNS 2000::1 и domain-search

![Команды настройки DHCPv6 Stateless](Screenshot_11.png){ width=78% }

## Stateless: проверка конфигурации (VyOS)

- В конфигурации присутствуют dhcpv6-server и router-advert
- Shared-network-name: dgavdadaev-stateless
- Передаются общие опции (DNS, domain-search)

![Фрагмент конфигурации DHCPv6 Stateless](Screenshot_12.png){ width=78% }

## PC2: IPv6-автоконфигурация (SLAAC)

- Получен глобальный адрес из 2000::/64
- Есть link-local fe80::/64
- Маршрут по умолчанию через RA

![IPv6 и маршруты на PC2](Screenshot_13.png){ width=78% }

## PC2: проверка связности

- ping 2000::1 успешен
- Подтверждена работа RA/SLAAC
- Доступность шлюза обеспечена

![Ping 2000::1 с PC2](Screenshot_14.png){ width=78% }

## PC2: DNS-параметры (Stateless)

- До DHCPv6: DNS может быть отсутствующим/дефолтным
- После запроса: применяется DNS из DHCPv6
- Проверка через /etc/resolv.conf

![DNS на PC2](Screenshot_15.png){ width=78% }

## Stateless: аренды DHCPv6 на VyOS

- Таблица leases без выданных IPv6-адресов
- Stateless не распределяет адреса
- DHCPv6 используется для «неадресных» параметров

![DHCPv6 leases (Stateless)](Screenshot_16.png){ width=78% }

## Stateless: анализ трафика (Wireshark)

- Solicit/Reply для параметров
- IAADDR отсутствует (адрес не выдаётся)
- Адрес формируется по SLAAC

![DHCPv6 Stateless в Wireshark](Screenshot_17.png){ width=78% }

# DHCPv6 Stateful

## Stateful: настройка RA и DHCPv6 (eth2)

- managed-flag: адрес через DHCPv6
- Пул: 2001::100–2001::199
- DNS: 2001::1, domain-search: dgavdadaev.net

![Команды настройки DHCPv6 Stateful](Screenshot_18.png){ width=78% }

## Stateful: аренды DHCPv6 на VyOS

- Появляются активные leases
- Видны IAID/DUID клиента
- Адрес из диапазона 2001::100–2001::199

![DHCPv6 leases (Stateful)](Screenshot_19.png){ width=78% }

## PC3: состояние до DHCPv6

- Присутствует link-local адрес
- Маршрут по умолчанию через RA
- DNS ещё не задан по IPv6

![IPv6 и маршруты на PC3 до DHCPv6](Screenshot_20.png){ width=78% }

## PC3: получение IPv6 по DHCPv6

- DHCPv6-клиент получает IPv6-адрес
- Адрес относится к 2001::/64
- Процедура выдачи завершена успешно

![Получение IPv6 по DHCPv6 на PC3](Screenshot_21.png){ width=78% }

## PC3: проверка после DHCPv6

- ping 2001::1 успешен
- DNS и search применены
- Маршрутизация корректна

![Проверка IPv6/DNS на PC3](Screenshot_22.png){ width=78% }

## Stateful: анализ трафика (Wireshark)

- Solicit → Advertise → Request → Reply
- В Reply присутствует IA_NA (выдача адреса)
- Передаются DNS-параметры сервера

![DHCPv6 Stateful в Wireshark](Screenshot_23.png){ width=78% }

# Итоги

## Заключение

- DHCP (IPv4) корректно распределяет адреса и параметры сети
- DHCPv6 Stateless: SLAAC выдаёт адрес, DHCPv6 — DNS/домен
- DHCPv6 Stateful: DHCPv6 выдаёт IPv6-адреса и ведёт учёт аренд
