import torch
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"ROCM devices: {torch.cuda.device_count()}")

tensor = torch.tensor([1]).to('cuda')
print(f"Tensor on device: {tensor.device}")
