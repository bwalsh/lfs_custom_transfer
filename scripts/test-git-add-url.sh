#!/usr/bin/env bash
set -euo pipefail

# Test script for git-add-url using public cloud buckets

SCRIPT="./git-add-url"  # adjust if your script is elsewhere

# S3 open data example
S3_URL="s3://1000genomes/phase1/analysis_results/integrated_call_sets/ALL.chr22.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.vcf.gz"
S3_OUT="test-s3.url.lfs"

# GCS public dataset
GCS_URL="gs://gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.fai"
GCS_OUT="test-gcs.url.lfs"

# Azure public blob example (requires no auth)
AZURE_URL="azure://azureopendatastorage/censusdatacontainer/ACSDT1Y2019.B01001_data_with_overlays_2022-10-18T154353.csv"
AZURE_OUT="test-azure.url.lfs"

echo "🔹 Testing S3"
$SCRIPT "$S3_URL" "$S3_OUT"
cat "$S3_OUT"

echo "🔹 Testing GCS"
$SCRIPT "$GCS_URL" "$GCS_OUT"
cat "$GCS_OUT"

echo "🔹 TODO Add Testing Azure"
#if [ -z "${AZURE_STORAGE_CONNECTION_STRING:-}" ]; then
#  echo "⚠️  Set AZURE_STORAGE_CONNECTION_STRING to test Azure blob access"
#else
#  $SCRIPT "$AZURE_URL" "$AZURE_OUT"
#  cat "$AZURE_OUT"
#fi
