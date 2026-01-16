# Stream Analyzer - Project Overview

## Purpose

Stream Analyzer is an open-source desktop application for analyzing H.264/H.265 video streams with detailed NAL unit inspection and frame visualization capabilities.

It is a powerful debugging tool designed for video codec developers and engineers who need to inspect H.264 and H.265 bitstreams at the NAL unit level.

## Key Features

### NAL Unit Analysis
- Hierarchical stream visualization with expandable tree structure
- Detailed NAL unit inspection (slice types, PPS, SPS, frame numbers, etc.)
- Complete NAL unit parameter viewing

### Binary Level Inspection
- Hex viewer with synchronized hex and ASCII views
- Offset navigation with hexadecimal addressing
- Real-time parameter decoding (forbidden_zero_bit, nal_ref_idc, slice_type, etc.)

### Frame Visualization
- Direct frame preview for I, P, and B frames
- Frame-by-frame navigation
- Visual frame type indicators
- Quick frame analysis for quality validation

## Use Cases

- Codec development and debugging
- Stream validation for H.264/H.265 standards compliance
- Quality analysis and encoding decision inspection
- Education: learning video compression internals
- Troubleshooting playback issues and stream corruption

## Supported Formats

- H.264/AVC elementary streams (.h264, .264)
- H.265/HEVC elementary streams (.h265, .265, .hevc)
- Annex B byte streams
- AVCC format
