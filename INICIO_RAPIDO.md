# 🚀 INICIO RÁPIDO - LAB CI/CD

## ⚡ Para comenzar inmediatamente:

### 1️⃣ Probar la API localmente (SIN Docker)
```powershell
.\test-local.ps1
```

### 2️⃣ Subir a GitHub
```powershell
.\init-github.ps1 -Usuario "tu-usuario-github"
```

### 3️⃣ Desplegar localmente (CON Docker)
```powershell
.\deploy-local.ps1 -Usuario "tu-usuario-github"
```

---

## 📁 Archivos importantes

| Archivo | Descripción |
|---------|-------------|
| `INSTRUCCIONES.md` | 📖 Guía paso a paso completa |
| `README.md` | 📝 Documentación técnica |
| `PLANTILLA_INFORME.md` | 📄 Plantilla para el informe |
| `test-local.ps1` | 🧪 Probar API sin Docker |
| `init-github.ps1` | 🐙 Subir código a GitHub |
| `deploy-local.ps1` | 🐳 Desplegar con Docker |

---

## 🎯 Endpoints de la API

Una vez desplegada, accede a:

- **Health:** http://localhost:8080/health
- **Ping:** http://localhost:8080/api/v1/ping
- **Version:** http://localhost:8080/version
- **Swagger:** http://localhost:8080/swagger

---

## 📋 Checklist del Laboratorio

### Parte A: Preparación
- [x] ✅ Proyecto .NET creado
- [x] ✅ Endpoints implementados
- [x] ✅ Compilación exitosa

### Parte B: Dockerización
- [x] ✅ Dockerfile creado
- [x] ✅ docker-compose.yml configurado

### Parte C: CI (Integración Continua)
- [ ] ⏳ Repositorio creado en GitHub
- [ ] ⏳ Código subido a GitHub
- [ ] ⏳ Workflow ejecutándose
- [ ] ⏳ Permisos configurados
- [ ] ⏳ Imagen publicada en GHCR

### Parte D: CD (Despliegue Continuo)
- [ ] ⏳ Docker Desktop instalado
- [ ] ⏳ Autenticación en GHCR
- [ ] ⏳ Imagen descargada
- [ ] ⏳ API desplegada localmente
- [ ] ⏳ Endpoints verificados

### Validación del Ciclo
- [ ] ⏳ Cambio realizado en el código
- [ ] ⏳ Commit y push
- [ ] ⏳ Workflow activado automáticamente
- [ ] ⏳ Nueva imagen generada
- [ ] ⏳ Despliegue actualizado
- [ ] ⏳ Cambio reflejado

### Informe
- [ ] ⏳ Capturas de pantalla tomadas
- [ ] ⏳ Informe completado
- [ ] ⏳ PDF generado
- [ ] ⏳ Subido a la plataforma

---

## 🆘 Ayuda Rápida

### Problema: Docker no funciona
```powershell
# Verificar Docker
docker --version
docker ps

# Si falla, reinicia Docker Desktop
```

### Problema: No puedo descargar la imagen
```powershell
# Autenticarse de nuevo
docker login ghcr.io

# Verificar que el usuario en docker-compose.yml sea correcto
```

### Problema: Los cambios no se reflejan
```powershell
# Actualizar forzadamente
docker compose down
docker compose pull
docker compose up -d --force-recreate
```

### Problema: El puerto 8080 está ocupado
```yaml
# En docker-compose.yml, cambiar:
ports:
  - "8081:8080"  # Usar 8081 en lugar de 8080
```

---

## 📞 Recursos Adicionales

- 📖 **Instrucciones completas:** `INSTRUCCIONES.md`
- 📚 **Documentación técnica:** `README.md`
- 📄 **Plantilla de informe:** `PLANTILLA_INFORME.md`
- 🔧 **Archivo de pruebas HTTP:** `Demo.CICD.Api/Demo.CICD.Api.http`

---

## 🎓 Preguntas Frecuentes

**P: ¿Necesito instalar algo más?**
R: Solo .NET 10, Docker Desktop y Git. Todo lo demás es automático.

**P: ¿Puedo usar mi propio repositorio?**
R: Sí, solo cambia el nombre cuando ejecutes `init-github.ps1`

**P: ¿Cuánto tarda el pipeline en ejecutarse?**
R: Entre 2-5 minutos, dependiendo de tu conexión a internet.

**P: ¿El repositorio debe ser público?**
R: Se recomienda público para evitar problemas con GHCR, pero puede ser privado.

**P: ¿Qué hago si el workflow falla?**
R: Ve a Actions en GitHub, clic en el workflow fallido, y revisa los logs para ver el error específico.

---

## ✅ Verificación Final

Antes de entregar, asegúrate de que:

1. ✅ La API responde correctamente en localhost:8080
2. ✅ El workflow de GitHub Actions está en verde
3. ✅ La imagen está publicada en GHCR
4. ✅ Tienes todas las capturas de pantalla
5. ✅ El informe está completo
6. ✅ El PDF está listo para subir

---

## 🎉 ¡Éxito!

Si llegaste hasta aquí y todo funciona, ¡felicidades! 🎊

Has implementado un flujo completo de CI/CD.

---

**Laboratorio 6 - Programación Avanzada**  
**Tecnologías de la Información - ESPE**  
**NRC: 30776**
