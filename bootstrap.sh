#!/bin/bash

# Зупиняємо виконання скрипта у разі виникнення помилки
set -e

echo "🚀 Створення кластера Kind..."
# Якщо кластер вже існує, ця команда може видати помилку.
# За потреби додай прапорець --name твій-кластер
kind create cluster --config cluster.yml

echo "⏳ Очікування готовності нод..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "📦 Розгортання ресурсів Kubernetes..."

# 1. Спочатку створюємо Секрети та ConfigMap-и
kubectl apply -f st-secret.yml
kubectl apply -f st-configMap.yml
kubectl apply -f app-secret.yml
# Застосуй конфігмап додатку, якщо він винесений в окремий файл
# kubectl apply -f app-configMap.yml

# 2. Створюємо Persistent Volumes та Claims
kubectl apply -f pv_tr.yml
kubectl apply -f pvc_tr.yml

# 3. Піднімаємо Сервіс та саму Базу Даних (StatefulSet)
kubectl apply -f st-service.yml
kubectl apply -f statefulSet.yml

# 4. Запускаємо сам Django-додаток
# Вкажи правильну назву файлу твого Deployment
# kubectl apply -f deployment.yml

echo "✅ Усі ресурси успішно застосовані!"
echo "👉 Перевірте статус подів командою: kubectl get pods -A"