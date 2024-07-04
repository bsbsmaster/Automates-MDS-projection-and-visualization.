#!/bin/bash

# Define paths
DISTANCE_MATRIX_FILE="distance_matrix.npy"
PYTHON_SCRIPT="mds_projection.py"

# Check if the distance matrix file exists
if [ ! -f "$DISTANCE_MATRIX_FILE" ]; then
    echo "Error: Distance matrix file '$DISTANCE_MATRIX_FILE' not found."
    exit 1
fi

# Create the Python script for MDS
cat << 'EOF' > $PYTHON_SCRIPT
import numpy as np
import matplotlib.pyplot as plt
from sklearn.manifold import MDS

def main():
    try:
        distance_matrix = np.load('distance_matrix.npy')
    except Exception as e:
        print(f"Error loading distance matrix: {e}")
        return

    print(f"Distance matrix shape: {distance_matrix.shape}")

    try:
        mds = MDS(n_components=2, dissimilarity='precomputed', random_state=42)
        points = mds.fit_transform(distance_matrix)
    except Exception as e:
        print(f"Error performing MDS: {e}")
        return

    plt.figure(figsize=(10, 8))
    plt.scatter(points[:, 0], points[:, 1])
    plt.title('MDS Projection of Distance Matrix')
    plt.xlabel('MDS Dimension 1')
    plt.ylabel('MDS Dimension 2')
   
    for i, point in enumerate(points):
        plt.annotate(str(i), (point[0], point[1]))

    plt.show()

if __name__ == "__main__":
    main()
EOF

# Run the Python script
python3 $PYTHON_SCRIPT

# Cleanup: remove the Python script
rm $PYTHON_SCRIPT
