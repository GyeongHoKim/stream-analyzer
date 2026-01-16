# Stream Analyzer

An open-source desktop application for analyzing H.264/H.265 video streams with detailed NAL unit inspection and frame visualization capabilities.

## Overview

Stream Analyzer is a powerful debugging tool designed for video codec developers and engineers who need to inspect H.264 and H.265 bitstreams at the NAL unit level. This open-source version provides comprehensive analysis capabilities previously only available in commercial tools.

## Features

### NAL Unit Analysis

- **Hierarchical Stream Visualization**: Navigate through elementary streams with expandable tree structure
- **Detailed NAL Unit Inspection**: View complete NAL unit parameters including:
  - Slice types (I, P, B frames)
  - Picture Parameter Sets (PPS)
  - Sequence Parameter Sets (SPS)
  - Frame numbers and slice indices
  - NAL unit types and reference information

### Binary Level Inspection

- **Hex Viewer**: Examine raw bitstream data with synchronized hex and ASCII views
- **Offset Navigation**: Precise byte-level positioning with hexadecimal addressing
- **Parameter Decoding**: Real-time decoding of syntax elements:
  - `forbidden_zero_bit`
  - `nal_ref_idc`
  - `nal_unit_type`
  - `first_mb_in_slice`
  - `slice_type`
  - Picture parameter IDs
  - Frame numbers
  - Deblocking filter parameters
  - And many more codec-specific fields

### Frame Visualization

- **Direct Frame Preview**: View decoded I, P, and B frames as images
- **Frame-by-Frame Navigation**: Step through video sequences frame by frame
- **Frame Type Indicators**: Visual distinction between frame types
- **Quick Frame Analysis**: Validate encoding quality and identify visual artifacts

## Use Cases

- **Codec Development**: Debug encoder/decoder implementations
- **Stream Validation**: Verify bitstream compliance with H.264/H.265 standards
- **Quality Analysis**: Inspect frame structures and encoding decisions
- **Education**: Learn video compression internals through hands-on exploration
- **Troubleshooting**: Diagnose playback issues and stream corruption

## Installation

Download the latest version for your operating system from the [Releases](https://github.com/GyeongHoKim/stream-analyzer/releases) page:

## Supported Formats

- H.264/AVC elementary streams (.h264, .264)
- H.265/HEVC elementary streams (.h265, .265, .hevc)
- Annex B byte streams
- AVCC format

## Building from Source

This project uses [Wails](https://wails.io/docs/introduction), you should install wails.

```bash
# Clone the repository
git clone https://github.com/GyeongHoKim/stream-analyzer.git

# Build for production
wails build
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Environment

This project uses [Wails](https://wails.io/docs/introduction) which uses react-ts template.  
Install Wails and NPM package manager.

```sh
# install dependencies
make install
# run vite dev server and wails
make dev
# build for production
make build
# biome lint & gofmt format
make lint
# vitest run & go test
make test
# remove dependencies folder
make clean
# list up commands
make help
```

## License

MIT License - See LICENSE file for details

## Acknowledgments

Inspired by professional stream analysis tools, this project aims to democratize access to advanced video codec debugging capabilities.
