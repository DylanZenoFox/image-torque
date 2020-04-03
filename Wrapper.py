import matlab.engine
import argparse

def main():

	Parser = argparse.ArgumentParser()
	Parser.add_argument('--ImagesDirectory', default="./images/", help='Image directory to compute torque, default: ./images/')
	Parser.add_argument('--NumExtrema', default="5",type= int, help='Number of torque extrema points to extract from image, default: 5')
	Parser.add_argument('--ResizeFactor', default="0.5",type = float, help='Factor to resize image before torque is computed, if tuple is given, default = 0.5')
	Parser.add_argument('--TorqueSizes', default="3:45:5", help='Range of sizes for torque operator patches, must be of form min:max:step_size, default = 3:45:5')
	Parser.add_argument('--CannyThresholdLow', default="0.2",type= float, help='Value of lower canny edge detection threshold, default: 0.1')
	Parser.add_argument('--CannyThresholdHigh', default="0.4",type= float, help='Value of higher canny edge detection threshold, default: 0.3')




	Args = Parser.parse_args()
	ImagesDirectory = Args.ImagesDirectory
	NumExtrema = Args.NumExtrema
	ResizeFactor = Args.ResizeFactor
	TorqueSizes = Args.TorqueSizes
	CannyThresholdHigh = Args.CannyThresholdHigh
	CannyThresholdLow = Args.CannyThresholdLow

	sizes = TorqueSizes.split(':')

	if(len(sizes) != 3):
		print("Error: Malformed TorqueSizes Input, must be of form min:max:step_size")
		return

	sizes = [int(i) for i in sizes]
	sizesList = list(range(sizes[0], sizes[1], sizes[2]))

	eng = matlab.engine.start_matlab()
	eng.addpath('./torque_code')
	eng.addpath('./torque_code/MAX-MOMENTS-PATCHES')
	points = eng.torque_set(NumExtrema, ImagesDirectory, ResizeFactor, sizesList, [CannyThresholdLow,CannyThresholdHigh])

	print(points)
	eng.quit()


if __name__ == '__main__':
	main()


