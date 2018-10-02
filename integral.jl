# I
function simpsonrep(f, a, b; m = 101)
    m % 2 == 0 && (m += 1)
    h = (b - a) / (m - 1)
    I1 = I2 = 0.0
    xi = a + h
    xj = a + 2 * h
    for i = 2 : 2 :m - 1
        I1 += f(xi)
        xi += 2 * h
    end
    for k = 3 : 2 : m - 2
        I2 += f(xj)
        xj += 2 * h
    end
    return I = (h/3) * (f(a) + 4 * I1 + 2 * I2 + f(b))    
end

function simpsoneps(f, a, b, ϵ; M = 1.0)
   h = ((180 * ϵ) / ((b - a) * M)) ^ (0.25)
   m = ceil(Int, (b - a)/ h + 1)
   return simpsonrep(f, a, b, m)
end

# II
function simpson(f, a, b)
    return ((b - a) / 6) * (f(a) + 4 * f((a + b) / 2) + f(b))
end

function simpson_adaptivo(f, a, b, ϵ)
    I = simpson(f, a, b)
    return simpson_adaptivo_recursivo(f, a, b, ϵ, I)
end

function simpson_adaptivo_recursivo(f, a, b, ϵ, I)
    c = (a + b) / 2
    esquerda = ((c - a) / 6) * (f(a) + 4 * f((a + c) / 2) + f(c)) #S(a,c)
    direita = ((b - c) / 6) * (f(c) + 4 * f((c + b) / 2) + f(b)) #S(c,b)
    if abs(I - esquerda - direita) <= 15 * ϵ
        return esquerda + direita
    else
        return simpson_adaptivo_recursivo(f, a, c, ϵ/2, esquerda) + simpson_adaptivo_recursivo(f, c, b, ϵ/2, direita)
    end
end
