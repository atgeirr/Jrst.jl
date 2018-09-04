module Sim
    export CartesianGrid
    export numCells
    export numFaces
    export numDirFaces
    export linToIJK
    export ijkToLin
    export entityIJKToFace
    export faceToEntityIJK
    export cellFaces
    export faceCells
    include("grid.jl")
end
