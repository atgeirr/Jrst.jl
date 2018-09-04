abstract type AbstractGrid end

struct CartesianGrid <: AbstractGrid
    dim::Tuple{Int64, Int64, Int64}
    extent::Tuple{Float64, Float64, Float64}
end

numCells(g::CartesianGrid) = g.dim[1] * g.dim[2] * g.dim[3]

mm(n) = mod(n-1, 3) + 1

numDirFaces(g::CartesianGrid, dir) = (g.dim[dir] + 1) * g.dim[mm(dir+1)] * g.dim[mm(dir+2)]
numFaces(g::CartesianGrid) = numDirFaces(g, 1) + numDirFaces(g, 2) + numDirFaces(g, 3)


function linToIJK(dim, cell::Integer)
    i = rem(cell - 1, dim[1]) + 1
    j = rem(div(cell - 1, dim[1]), dim[2]) + 1
    k = div(cell - 1, dim[1]*dim[2]) + 1
    (i, j, k)
end

function ijkToLin(dim, ijk)
    if any(ijk .< 1)
        return 0
    elseif any(ijk .> dim)
        return 0
    end
    ijk[1] + dim[1]*(ijk[2] - 1 + dim[2]*(ijk[3] - 1))
end

linToIJK(g::CartesianGrid, cell::Integer) = linToIJK(g.dim, cell)
ijkToLin(g::CartesianGrid, ijk) = ijkToLin(g.dim, ijk)

function firstEven(x)
    for i = 1:length(x)
        if rem(x[i], 2) == 0
            return i
        end
    end
    return 0
end

function firstOdd(x)
    for i = 1:length(x)
        if rem(x[i], 2) == 1
            return i
        end
    end
    return 0
end



function entityIJKToFace(g::CartesianGrid, eijk)
    f = 0
    q = firstOdd(eijk)
    for dir = 1:(q-1)
        f += numDirFaces(g, dir)
    end
    dim = [g.dim...]
    ijk = [eijk...]
    dim[q] += 1
    ijk[q] += 1
    f += ijkToLin(dim, div.(ijk, 2))
    return f
end

function faceToEntityIJK(g::CartesianGrid, face::Integer)
    dim = [g.dim...]
    for dir = 1:3
        dirfaces = numDirFaces(g, dir)
        if face <= dirfaces
            dim[dir] += 1
            ijk = [linToIJK(dim, face)...]
            ijk = 2.*ijk
            ijk[dir] -= 1
            return (ijk[1], ijk[2], ijk[3])
        else
            face -= dirfaces
        end
    end
    return (0, 0, 0)
end

function cellFaces(g::CartesianGrid, ijk)
    (i, j, k) = ijk
    entity_ijk = [
        (2i - 1, 2j, 2k),
        (2i + 1, 2j, 2k),
        (2i, 2j - 1, 2k),
        (2i, 2j + 1, 2k),
        (2i, 2j, 2k - 1),
        (2i, 2j, 2k + 1),
    ]
    map(x->entityIJKToFace(g,x), entity_ijk)
end

cellFaces(g::CartesianGrid, cell::Integer) = cellFaces(g, linToIJK(g, cell))

function faceCells(g::CartesianGrid, face::Integer)
    ijk1 = [faceToEntityIJK(g, face)...]
    ijk2 = copy(ijk1)
    dir = firstOdd(ijk1)
    ijk1[dir] -= 1;
    ijk2[dir] += 1;
    eijk_cells = div.((ijk1, ijk2), 2)
    map(x->ijkToLin(g, x), eijk_cells)
end
