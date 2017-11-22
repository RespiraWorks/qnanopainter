#ifndef QNANOBACKENDFACTORY_H
#define QNANOBACKENDFACTORY_H

#ifndef QT_OPENGL_ES_2
#include "private/qnanobackendgl2.h"
#endif
#ifdef QT_OPENGL_3_2
#include "private/qnanobackendgl3.h"
#endif
#if defined(QT_OPENGL_ES_2) || defined(QT_OPENGL_ES_3) || defined(QT_OPENGL_ES_2_ANGLE)
#include "private/qnanobackendgles2.h"
#include "private/qnanobackendgles3.h"
#endif

class QNanoBackendFactory
{
public:

    static QNanoBackend *createBackend(int major, int minor, bool isGLES) {

#ifndef QNANO_ENABLE_GLES3
        // OpenGL ES 3.0 is disabled, so force ES 2.0 backend
        if (isGLES) {
            major = 2;
            minor = 0;
        }
#else
        Q_UNUSED(minor);
#endif

        qDebug("Creating QNanoBackend for %s %d.%d", (isGLES ? "OpenGL ES" : "OpenGL"), major, minor);

        if (isGLES) {
#if defined(QT_OPENGL_ES_2) || defined(QT_OPENGL_ES_3) || defined(QT_OPENGL_ES_2_ANGLE)
            if (major >= 3) {
                return new QNanoBackendGLES3();
            } else {
                return new QNanoBackendGLES2();
            }
#endif
        } else {
            if (major >= 3) {
#ifdef QT_OPENGL_3
                return new QNanoBackendGL3();
#endif
            } else {
#ifndef QT_OPENGL_ES_2
                return new QNanoBackendGL2();
#endif
            }
        }
        qWarning("Creating QNanoBackend for %s %d.%d failed!", (isGLES ? "OpenGL ES" : "OpenGL"), major, minor);
        return nullptr;
    }
};

#endif // QNANOBACKENDFACTORY_H
